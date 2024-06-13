defmodule ExchangeZoo.MEXC.SpotRequest do
  alias ExchangeZoo.{Response, Request}
  alias ExchangeZoo.MEXC.Model.SpotError

  def perform_public(url, method, params, mod) do
    url = append_query_params(url, params)

    Finch.build(method, url)
    |> Request.perform(mod, SpotError, &decode/3)
  end

  def perform_private(url, :get, params, mod, opts) do
    url = append_query_params(url, params)

    Finch.build(:get, url)
    |> append_headers(opts)
    |> Request.perform(mod, SpotError, &decode/3)
  end

  def perform_private(url, method, params, mod, opts) do
    body = Jason.encode!(params)

    Finch.build(method, url, [], body)
    |> append_headers(opts)
    |> Request.perform(mod, SpotError, &decode/3)
  end

  def append_query_params(%URI{} = uri, opts) do
    now = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    opts =
      opts
      |> Keyword.put_new(:timestamp, now)
      |> Keyword.put_new(:recv_window, 5000)

    Request.append_query_params(uri, opts)
  end

  defp append_headers(request, opts) do
    api_key = Keyword.fetch!(opts, :api_key)
    secret_key = Keyword.fetch!(opts, :secret_key)

    request
    |> Request.add_header("X-MEXC-APIKEY", api_key)
    |> Request.add_header("Content-Type", "application/json")
    |> Request.put_query_signature("Signature", secret_key, fn request ->
      "#{api_key}#{request.query}#{request.body}" |> dbg()
    end)
  end

  defp decode(%Finch.Response{status: 200} = response, mod, error_mod) do
    response = Response.decompress_body(response)

    case Jason.decode(response.body) do
      {:ok, %{"success" => true, "code" => 0, "data" => data}} ->
        {:ok, Request.model_from_data(data, mod)}

      {:ok, %{"success" => true, "code" => 0}} ->
        :ok

      {:ok, %{"success" => false} = data} ->
        {:error, response.status, Request.model_from_data(data, error_mod)}

      {:ok, data} ->
        {:ok, Request.model_from_data(data, mod)}

      {:error, reason} ->
        {:error, response.status, reason}
    end
  end

  defp decode(response, _mod, error_mod) do
    response = Response.decompress_body(response)

    case Jason.decode(response.body) do
      {:ok, data} ->
        {:error, response.status, Request.model_from_data(data, error_mod)}

      {:error, reason} ->
        {:error, response.status, reason}
    end
  end
end
