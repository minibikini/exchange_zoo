defmodule ExchangeZoo.Binance.Request do
  alias ExchangeZoo.Request
  alias ExchangeZoo.Binance.Model.Error

  def perform_public(url, method, params, mod) do
    url = append_query_params(url, params)

    Finch.build(method, url)
    |> Request.perform(mod)
  end

  def perform_private(url, method, params, mod, opts) do
    url = append_query_params(url, params)

    api_key = Keyword.fetch!(opts, :api_key)
    secret_key = Keyword.fetch!(opts, :secret_key)

    Finch.build(method, url)
    |> Request.add_header("X-MBX-APIKEY", api_key)
    |> Request.put_query_signature("signature", secret_key)
    |> Request.perform(mod, Error)
  end

  def append_query_params(%URI{} = uri, opts) do
    now = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    opts = Keyword.put_new(opts, :timestamp, now)

    Request.append_query_params(uri, opts)
  end
end
