defmodule ExchangeZoo.BitMEX.Request do
  alias ExchangeZoo.Request
  alias ExchangeZoo.BitMEX.Model.Error

  def perform_public(url, method, params, mod) do
    url = append_query_params(url, params)

    Finch.build(method, url)
    |> Request.perform(mod, Error)
  end

  def perform_private(url, :get, _params, mod, opts) do
    Finch.build(:get, url, [], nil)
    |> append_headers(opts)
    |> Request.perform(mod, Error, &decode/3)
  end

  def perform_private(url, method, params, mod, opts) do
    body = Jason.encode!(params)

    Finch.build(method, url, [], body)
    |> append_headers(opts)
    |> Request.perform(mod, Error, &decode/3)
  end

  defdelegate append_query_params(uri, opts), to: Request

  defp append_headers(request, opts) do
    api_key = Keyword.fetch!(opts, :api_key)
    secret_key = Keyword.fetch!(opts, :secret_key)

    timestamp =
      Keyword.get(opts, :timestamp, DateTime.utc_now() |> DateTime.to_unix(:millisecond))

    recv_window = Keyword.get(opts, :recv_window, 5000)

    expires = ceil((timestamp + recv_window) / 1000)

    request
    |> Request.add_header("api-key", api_key)
    |> Request.add_header("api-expires", to_string(expires))
    |> Request.add_header("content-type", "application/json")
    |> Request.put_header_signature("api-signature", secret_key, fn request ->
      "#{request.method}#{request.path}#{request.query}#{expires}#{request.body}"
    end)
  end

  defp decode(%Finch.Response{status: 200} = response, mod, _error_mod) do
    case Jason.decode(response.body) do
      {:ok, data} ->
        {:ok, Request.model_from_data(data, mod)}

      {:error, reason} ->
        {:error, response.status, reason}
    end
  end

  defp decode(response, _mod, error_mod) do
    case Jason.decode(response.body) do
      {:ok, %{"error" => data}} ->
        {:error, response.status, Request.model_from_data(data, error_mod)}

      {:error, reason} ->
        {:error, response.status, reason}
    end
  end
end
