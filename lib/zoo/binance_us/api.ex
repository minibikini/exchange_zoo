defmodule ExchangeZoo.BinanceUS.API do
  import ExchangeZoo.BinanceUS.Request
  alias ExchangeZoo.BinanceUS.Model.BookTicker

  @base_url "https://api.binance.us"

  def get_order_book_ticker(params \\ [], opts \\ []) do
    build_url!("/api/v3/ticker/bookTicker", opts)
    |> append_query_params(params)
    |> perform_public(:get, BookTicker)
  end

  defp build_url!(path, opts) do
    opts = Keyword.merge([uri: @base_url], opts)
    URI.new!(opts[:uri] <> path)
  end

  defp append_query_params(%URI{} = uri, opts) do
    URI.append_query(uri, URI.encode_query(opts))
  end
end
