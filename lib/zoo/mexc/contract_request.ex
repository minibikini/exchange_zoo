defmodule ExchangeZoo.MEXC.ContractRequest do
  alias ExchangeZoo.Request
  alias ExchangeZoo.MEXC.Model.ContractError

  def perform_public(url, method, params, mod) do
    url = append_query_params(url, params)

    Finch.build(method, url)
    |> Request.perform(mod, ContractError, &decode/3)
  end

  def perform_private(url, :get, params, mod, opts) do
    url = append_query_params(url, params)

    Finch.build(:get, url)
    |> append_headers(opts)
    |> Request.perform(mod, ContractError, &decode/3)
  end

  def perform_private(url, method, params, mod, opts) do
    body = Jason.encode!(params)

    Finch.build(method, url, [], body)
    |> append_headers(opts)
    |> Request.perform(mod, ContractError, &decode/3)
  end

  defdelegate append_query_params(uri, opts), to: Request

  defp append_headers(request, opts) do
    api_key = Keyword.fetch!(opts, :api_key)
    secret_key = Keyword.fetch!(opts, :secret_key)

    timestamp =
      Keyword.get(opts, :timestamp, DateTime.utc_now() |> DateTime.to_unix(:millisecond))

    recv_window = Keyword.get(opts, :recv_window, 5000)

    request
    |> Request.add_header("ApiKey", api_key)
    |> Request.add_header("Request-Time", to_string(timestamp))
    |> Request.add_header("Recv-Window", to_string(recv_window))
    |> Request.add_header("Content-Type", "application/json")
    |> Request.put_header_signature("Signature", secret_key, fn request ->
      "#{api_key}#{timestamp}#{request.query}#{request.body}" |> dbg()
    end)
  end

  defp decode(%Finch.Response{status: 200} = response, mod, error_mod) do
    case Jason.decode(response.body) do
      {:ok, %{"success" => true, "code" => 0, "data" => data}} ->
        {:ok, Request.model_from_data(data, mod)}

      {:ok, %{"success" => true, "code" => 0}} ->
        :ok

      {:ok, %{"success" => false} = data} ->
        {:error, response.status, Request.model_from_data(data, error_mod)}

      {:error, reason} ->
        {:error, response.status, reason}
    end
  end

  defp decode(response, _mod, error_mod) do
    case Jason.decode(response.body) do
      {:ok, data} ->
        {:error, response.status, Request.model_from_data(data, error_mod)}

      {:error, reason} ->
        {:error, response.status, reason}
    end
  end
end
