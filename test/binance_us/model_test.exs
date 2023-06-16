defmodule ExchangeZoo.BinanceUS.ModelTest do
  use ExUnit.Case, async: true
  import ExchangeZoo.Fixtures

  describe "BookTicker" do
    alias ExchangeZoo.BinanceUS.Model.BookTicker

    test "should parse /api/v3/ticker/bookTicker" do
      expected = [
        %BookTicker{
          symbol: "BTCUSDT",
          bid_price: Decimal.new("4.00000000"),
          bid_qty: Decimal.new("431.00000000"),
          ask_price: Decimal.new("4.00000200"),
          ask_qty: Decimal.new("9.00000000")
        }
      ]

      assert expected ==
               json_fixture("binance_us/api_v3_ticker_bookTicker")
               |> Enum.map(&BookTicker.from!/1)
    end
  end

  describe "BookTickerEvent" do
    alias ExchangeZoo.BinanceUS.Model.BookTickerEvent

    test "should parse bookTicker event" do
      expected = %BookTickerEvent{
        order_book_update_id: 400_900_217,
        symbol: "BNBUSDT",
        best_bid_price: Decimal.new("25.35190000"),
        best_bid_qty: Decimal.new("31.21000000"),
        best_ask_price: Decimal.new("25.36520000"),
        best_ask_qty: Decimal.new("40.66000000")
      }

      assert expected ==
               json_fixture("binance_us/events/book_ticker")
               |> BookTickerEvent.from!()
    end
  end
end
