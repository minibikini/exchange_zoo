defmodule ExchangeZoo.Bybit.Request do
  alias ExchangeZoo.Request
  alias ExchangeZoo.Bybit.Model.Error

  def perform_public(url, method, mod) do
    Finch.build(method, url)
    |> Request.perform(mod, Error, &decoder/2)
  end

  def perform_private(url, method, mod, opts) do
    api_key = Keyword.fetch!(opts, :api_key)
    secret_key = Keyword.fetch!(opts, :secret_key)
    timestamp = Keyword.get(opts, :timestamp, DateTime.utc_now() |> DateTime.to_unix(:millisecond))
    recv_window = Keyword.get(opts, :recv_window, 5000)

    Finch.build(method, url)
    |> Request.add_header("X-BAPI-API-KEY", api_key)
    |> Request.add_header("X-BAPI-TIMESTAMP", timestamp)
    |> Request.add_header("X-BAPI-RECV-WINDOW", recv_window)
    |> Request.put_header_signature("X-BAPI-SIGN", secret_key, fn request ->
      "#{timestamp}#{api_key}#{recv_window}#{request.query}#{request.body}"
    end)
    |> Request.perform(mod, Error, &decoder/2)
  end

  defdelegate append_query_params(uri, opts), to: Request

  defp decoder(body, mod) do
    case Jason.decode(body) do
      {:ok, %{"retCode" => 0, "result" => data}} -> {:ok, Request.model_from_data(data |> IO.inspect(), mod)}
      {:ok, data} -> {:error, Request.model_from_data(data, Error)}
      {:error, _reason} -> {:error, body}
    end
  end
end
