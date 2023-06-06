defmodule ExchangeZoo.Binance.Request do
  alias ExchangeZoo.Request
  alias ExchangeZoo.Binance.Model.Error

  def perform_public(url, method, mod) do
    Finch.build(method, url)
    |> Request.perform(mod)
  end

  def perform_private(url, method, mod, opts) do
    api_key = Keyword.get(opts, :api_key, get_api_key())
    secret_key = Keyword.get(opts, :secret_key, get_secret_key())

    Finch.build(method, url)
    |> Request.add_header("X-MBX-APIKEY", api_key)
    |> Request.put_query_signature("signature", secret_key)
    |> Request.perform(mod, Error)
  end

  defp get_api_key() do
    System.get_env("BINANCE_FUTURES_API_KEY")
  end

  defp get_secret_key() do
    System.get_env("BINANCE_FUTURES_API_SECRET")
  end
end
