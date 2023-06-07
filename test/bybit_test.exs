defmodule ExchangeZoo.BybitTest do
  use ExUnit.Case, async: true
  import ExchangeZoo.Fixtures

  describe "InstrumentsInfo" do
    alias ExchangeZoo.Bybit.Model.InstrumentsInfo

    alias ExchangeZoo.Bybit.Model.InstrumentsInfo.Instrument.{
      LeverageFilter,
      PriceFilter,
      LotSizeFilter
    }

    test "should parse /v5/market/instruments-info" do
      expected = %InstrumentsInfo{
        category: :linear,
        next_page_cursor: nil,
        list: [
          %InstrumentsInfo.Instrument{
            symbol: "BTCUSDT",
            contract_type: :linear_perpetual,
            status: :trading,
            base_coin: "BTC",
            quote_coin: "USDT",
            launch_time: 1_585_526_400_000,
            delivery_time: 0,
            delivery_fee_rate: nil,
            price_scale: Decimal.new(2),
            leverage_filter: %LeverageFilter{
              min_leverage: Decimal.new("1"),
              max_leverage: Decimal.new("100.00"),
              leverage_step: Decimal.new("0.01")
            },
            price_filter: %PriceFilter{
              min_price: Decimal.new("0.50"),
              max_price: Decimal.new("999999.00"),
              tick_size: Decimal.new("0.50")
            },
            lot_size_filter: %LotSizeFilter{
              max_order_qty: Decimal.new("100.000"),
              min_order_qty: Decimal.new("0.001"),
              qty_step: Decimal.new("0.001"),
              post_only_max_order_qty: Decimal.new("1000.000")
            },
            unified_margin_trade: true,
            funding_interval: 480,
            settle_coin: "USDT"
          }
        ]
      }

      assert expected ==
               json_fixture("bybit/v5_market_instruments-info")
               |> InstrumentsInfo.from!()
    end
  end

  describe "OrderResponse" do
    alias ExchangeZoo.Bybit.Model.OrderResponse

    test "should parse /v5/order/create" do
      expected = %OrderResponse{
        order_id: "1321003749386327552",
        order_link_id: "spot-test-postonly"
      }

      assert expected ==
               json_fixture("bybit/v5_order_create")
               |> OrderResponse.from!()
    end
  end
end
