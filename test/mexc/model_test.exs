defmodule ExchangeZoo.MEXC.ModelTest do
  use ExUnit.Case, async: true
  import ExchangeZoo.Fixtures

  describe "AccountAsset" do
    alias ExchangeZoo.MEXC.Model.AccountAsset

    test "should parse /v1/private/account/assets" do
      expected = [
        %AccountAsset{
          currency: "USDT",
          position_margin: Decimal.new("0"),
          available_balance: Decimal.new("0.03176562"),
          cash_balance: Decimal.new("0.03176562"),
          frozen_balance: Decimal.new("0"),
          equity: Decimal.new("0.03176562"),
          unrealized: Decimal.new("0"),
          bonus: Decimal.new("0")
        }
      ]

      assert expected ==
               json_fixture("mexc/v1_private_account_assets")
               |> Enum.map(&AccountAsset.from!/1)
    end
  end

  describe "Leverage" do
    alias ExchangeZoo.MEXC.Model.Leverage

    test "should parse /v1/private/position/leverage" do
      expected = [
        %Leverage{
          position_type: :long,
          level: 5,
          leverage: 20,
          imr: Decimal.new("0.021"),
          mmr: Decimal.new("0.02")
        },
        %Leverage{
          position_type: :short,
          level: 5,
          leverage: 20,
          imr: Decimal.new("0.021"),
          mmr: Decimal.new("0.02")
        }
      ]

      assert expected ==
               json_fixture("mexc/v1_private_position_leverage")
               |> Enum.map(&Leverage.from!/1)
    end
  end

  describe "Order" do
    alias ExchangeZoo.MEXC.Model.Order

    test "should parse /v1/private/order/list/open_orders" do
      expected = [
        %Order{
          order_id: "102015012431820288",
          symbol: "ETH_USDT",
          position_id: 1394917,
          price: Decimal.new("1209.05"),
          vol: Decimal.new("1"),
          leverage: 0,
          side: :close_short,
          category: :limit_order,
          order_type: :market_order,
          deal_avg_price: Decimal.new("1208.35"),
          deal_vol: Decimal.new("1"),
          order_margin: Decimal.new("0"),
          taker_fee: Decimal.new("0.0072501"),
          maker_fee: Decimal.new("0"),
          profit: Decimal.new("0"),
          fee_currency: "USDT",
          open_type: :isolated,
          state: :completed,
          external_oid: "_m_f95eb99b061d4eef8f64a04e9ac4dad3",
          error_code: :normal,
          used_margin: Decimal.new("0"),
          create_time: 1609992674000,
          update_time: 1609992674000,
          stop_loss_price: Decimal.new("0.0"),
          take_profit_price: Decimal.new("0.0")
        }
      ]

      assert expected ==
               json_fixture("mexc/v1_private_order_list_open_orders")
               |> Enum.map(&Order.from!/1)
    end
  end

  describe "ExchangeInfo" do
    alias ExchangeZoo.MEXC.Model.ExchangeInfo
    alias ExchangeZoo.MEXC.Model.ExchangeInfo.Symbol

    test "should parse /v3/exchangeInfo" do
      expected = %ExchangeInfo{
        timezone: "CST",
        server_time: 1_702_757_582_905,
        rate_limits: [],
        exchange_filters: [],
        symbols: [
          %Symbol{
            symbol: "BTCUSDT",
            full_name: "Bitcoin",
            status: :enabled,
            base_asset: "BTC",
            base_asset_precision: 6,
            quote_asset: "USDT",
            quote_precision: 2,
            quote_asset_precision: 2,
            base_commission_precision: 6,
            quote_commission_precision: 2,
            order_types: [:limit, :market, :limit_maker],
            is_spot_trading_allowed: false,
            is_margin_trading_allowed: false,
            quote_amount_precision: Decimal.new("5.000000000000000000"),
            base_size_precision: Decimal.new("0.000001"),
            permissions: [
              "SPOT"
            ],
            filters: [],
            max_quote_amount: Decimal.new("2000000.000000000000000000"),
            maker_commission: Decimal.new("0"),
            taker_commission: Decimal.new("0"),
            quote_amount_precision_market: Decimal.new("5.000000000000000000"),
            max_quote_amount_market: Decimal.new("100000.000000000000000000")
          }
        ]
      }

      assert expected ==
               json_fixture("mexc/v3_exchangeInfo")
               |> ExchangeInfo.from!()
    end
  end

  describe "ContractDetail" do
    alias ExchangeZoo.MEXC.Model.ContractDetail

    test "should parse /v1/contract/detail" do
      expected = [
        %ContractDetail{
          symbol: "BTC_USDT",
          display_name: "BTC_USDT永续",
          display_name_en: "BTC_USDT PERPETUAL",
          position_open_type: :both,
          base_coin: "BTC",
          quote_coin: "USDT",
          settle_coin: "USDT",
          contract_size: Decimal.new("0.0001"),
          min_leverage: 1,
          max_leverage: 200,
          price_scale: 1,
          vol_scale: 0,
          amount_scale: 4,
          price_unit: Decimal.new("0.1"),
          vol_unit: 1,
          min_vol: Decimal.new("1"),
          max_vol: Decimal.new("2625000"),
          bid_limit_price_rate: Decimal.new("0.1"),
          ask_limit_price_rate: Decimal.new("0.1"),
          taker_fee_rate: Decimal.new("0.0003"),
          maker_fee_rate: Decimal.new("0"),
          maintenance_margin_rate: Decimal.new("0.004"),
          initial_margin_rate: Decimal.new("0.005"),
          risk_base_vol: Decimal.new("525000"),
          risk_incr_vol: Decimal.new("525000"),
          risk_incr_mmr: Decimal.new("0.004"),
          risk_incr_imr: Decimal.new("0.004"),
          risk_level_limit: 5,
          price_coefficient_variation: Decimal.new("0.001"),
          index_origin: ["BITGET", "BYBIT", "BINANCE", "HUOBI", "OKX", "MEXC", "KUCOIN"],
          state: :enabled,
          is_new: false,
          is_hot: false,
          is_hidden: false,
          concept_plate: ["mc-trade-zone-pow"],
          risk_limit_type: :by_volume,
          max_num_orders: [200, 50],
          market_order_max_level: 20,
          market_order_price_limit_rate1: Decimal.new("0.2"),
          market_order_price_limit_rate2: Decimal.new("0.005"),
          trigger_protect: Decimal.new("0.1"),
          appraisal: 0,
          show_appraisal_countdown: 0,
          automatic_delivery: 0,
          api_allowed: false
        }
      ]

      assert expected ==
               json_fixture("mexc/v1_contract_detail")
               |> Enum.map(&ContractDetail.from!/1)
    end
  end
end
