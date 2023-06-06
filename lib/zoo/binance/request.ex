defmodule ExchangeZoo.Binance.Request do
  alias ExchangeZoo.Request
  alias ExchangeZoo.Binance.Model.Error

  def perform_public(url, method, mod) do
    Finch.build(method, url)
    |> Request.perform(mod)
  end

  def perform_private(url, method, mod, opts) do
    api_key = Keyword.fetch!(opts, :api_key)
    secret_key = Keyword.fetch!(opts, :secret_key)

    Finch.build(method, url)
    |> Request.add_header("X-MBX-APIKEY", api_key)
    |> Request.put_query_signature("signature", secret_key)
    |> Request.perform(mod, Error)
  end
end
