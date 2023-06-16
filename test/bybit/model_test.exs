defmodule ExchangeZoo.Bybit.ModelTest do
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

  describe "OrderEvent" do
    alias ExchangeZoo.Bybit.Model.OrderEvent

    test "should parse order event" do
      expected = %OrderEvent{
        symbol: "ETH-30DEC22-1400-C",
        order_id: "5cf98598-39a7-459e-97bf-76ca765ee020",
        side: :sell,
        order_type: :market,
        cancel_type: :unknown,
        price: Decimal.new("72.5"),
        qty: Decimal.new("1"),
        time_in_force: :ioc,
        order_status: :filled,
        reduce_only: false,
        cum_exec_qty: Decimal.new("1"),
        cum_exec_value: Decimal.new("75"),
        avg_price: Decimal.new("75"),
        position_idx: :both,
        cum_exec_fee: Decimal.new("0.358635"),
        created_time: 1672364262444,
        updated_time: 1672364262457,
        reject_reason: :ec__no_error,
        trigger_direction: :none,
        close_on_trigger: false,
        category: :option,
        place_type: :price,
        smp_type: :none,
        smp_group: 0
      }

      assert expected ==
               json_fixture("bybit/events/order_event")
               |> OrderEvent.from!()
    end
  end

  describe "ExecutionEvent" do
    alias ExchangeZoo.Bybit.Model.ExecutionEvent

    test "should parse execution event" do
      expected = %ExecutionEvent{
        category: :linear,
        symbol: "XRPUSDT",
        exec_fee: Decimal.new("0.005061"),
        exec_id: "7e2ae69c-4edf-5800-a352-893d52b446aa",
        exec_price: Decimal.new("0.3374"),
        exec_qty: Decimal.new("25"),
        exec_type: :trade,
        exec_value: Decimal.new("8.435"),
        is_maker: false,
        fee_rate: Decimal.new("0.0006"),
        mark_price: Decimal.new("0.3391"),
        leaves_qty: Decimal.new("0"),
        order_id: "f6e324ff-99c2-4e89-9739-3086e47f9381",
        order_price: Decimal.new("0.3207"),
        order_qty: Decimal.new("25"),
        order_type: :market,
        stop_order_type: :unknown,
        side: :sell,
        exec_time: 1672364174443,
        is_leverage: false
      }

      assert expected ==
        json_fixture("bybit/events/execution_event")
        |> ExecutionEvent.from!()
    end
  end

  describe "PositionEvent" do
    alias ExchangeZoo.Bybit.Model.PositionEvent

    test "should parse position event" do
      expected = %PositionEvent{
        position_idx: :both,
        trade_mode: :cross,
        risk_id: 41,
        risk_limit_value: Decimal.new("200000"),
        symbol: "XRPUSDT",
        side: :buy,
        size: Decimal.new("75"),
        entry_price: Decimal.new("0.3615"),
        leverage: Decimal.new("10"),
        position_value: Decimal.new("27.1125"),
        position_balance: Decimal.new("0"),
        mark_price: Decimal.new("0.3374"),
        position_im: Decimal.new("2.72589075"),
        position_mm: Decimal.new("0.28576575"),
        take_profit: Decimal.new("0"),
        stop_loss: Decimal.new("0"),
        trailing_stop: Decimal.new("0"),
        unrealised_pnl: Decimal.new("-1.8075"),
        cum_realised_pnl: Decimal.new("0.64782276"),
        created_time: 1672121182216,
        updated_time: 1672364174449,
        tpsl_mode: :full,
        category: :linear,
        position_status: :normal,
        adl_rank_indicator: 2
      }

      assert expected ==
        json_fixture("bybit/events/position_event")
        |> PositionEvent.from!()
    end
  end

  describe "WalletEvent" do
    alias ExchangeZoo.Bybit.Model.WalletEvent
    alias ExchangeZoo.Bybit.Model.WalletEvent.Coin

    test "should parse wallet event" do
      expected = %WalletEvent{
        account_im_rate: Decimal.new("0.016"),
        account_mm_rate: Decimal.new("0.003"),
        total_equity: Decimal.new("12837.78330098"),
        total_wallet_balance: Decimal.new("12840.4045924"),
        total_margin_balance: Decimal.new("12837.78330188"),
        total_available_balance: Decimal.new("12632.05767702"),
        total_perp_upl: Decimal.new("-2.62129051"),
        total_initial_margin: Decimal.new("205.72562486"),
        total_maintenance_margin: Decimal.new("39.42876721"),
        account_type: :unified,
        account_ltv: Decimal.new("0.017"),
        coin: [
          %Coin{
            coin: "USDC",
            equity: Decimal.new("200.62572554"),
            usd_value: Decimal.new("200.62572554"),
            wallet_balance: Decimal.new("201.34882644"),
            available_to_withdraw: Decimal.new("0"),
            available_to_borrow: Decimal.new("1500000"),
            borrow_amount: Decimal.new("0"),
            accrued_interest: Decimal.new("0"),
            total_order_im: Decimal.new("0"),
            total_position_im: Decimal.new("202.99874213"),
            total_position_mm: Decimal.new("39.14289747"),
            unrealised_pnl: Decimal.new("74.2768991"),
            cum_realised_pnl: Decimal.new("-209.1544627"),
            bonus: Decimal.new("0")
          },
          %Coin{
            coin: "BTC",
            equity: Decimal.new("0.06488393"),
            usd_value: Decimal.new("1023.08402268"),
            wallet_balance: Decimal.new("0.06488393"),
            available_to_withdraw: Decimal.new("0.06488393"),
            available_to_borrow: Decimal.new("2.5"),
            borrow_amount: Decimal.new("0"),
            accrued_interest: Decimal.new("0"),
            total_order_im: Decimal.new("0"),
            total_position_im: Decimal.new("0"),
            total_position_mm: Decimal.new("0"),
            unrealised_pnl: Decimal.new("0"),
            cum_realised_pnl: Decimal.new("0"),
            bonus: Decimal.new("0")
          },
          %Coin{
            coin: "ETH",
            equity: Decimal.new("0"),
            usd_value: Decimal.new("0"),
            wallet_balance: Decimal.new("0"),
            available_to_withdraw: Decimal.new("0"),
            available_to_borrow: Decimal.new("26"),
            borrow_amount: Decimal.new("0"),
            accrued_interest: Decimal.new("0"),
            total_order_im: Decimal.new("0"),
            total_position_im: Decimal.new("0"),
            total_position_mm: Decimal.new("0"),
            unrealised_pnl: Decimal.new("0"),
            cum_realised_pnl: Decimal.new("0"),
            bonus: Decimal.new("0")
          },
          %Coin{
            coin: "USDT",
            equity: Decimal.new("11726.64664904"),
            usd_value: Decimal.new("11613.58597018"),
            wallet_balance: Decimal.new("11728.54414904"),
            available_to_withdraw: Decimal.new("11723.92075829"),
            available_to_borrow: Decimal.new("2500000"),
            borrow_amount: Decimal.new("0"),
            accrued_interest: Decimal.new("0"),
            total_order_im: Decimal.new("0"),
            total_position_im: Decimal.new("2.72589075"),
            total_position_mm: Decimal.new("0.28576575"),
            unrealised_pnl: Decimal.new("-1.8975"),
            cum_realised_pnl: Decimal.new("0.64782276"),
            bonus: Decimal.new("0")
          },
          %Coin{
            coin: "EOS3L",
            equity: Decimal.new("215.0570412"),
            usd_value: Decimal.new("0"),
            wallet_balance: Decimal.new("215.0570412"),
            available_to_withdraw: Decimal.new("215.0570412"),
            available_to_borrow: Decimal.new("0"),
            borrow_amount: Decimal.new("0"),
            accrued_interest: nil,
            total_order_im: Decimal.new("0"),
            total_position_im: Decimal.new("0"),
            total_position_mm: Decimal.new("0"),
            unrealised_pnl: Decimal.new("0"),
            cum_realised_pnl: Decimal.new("0"),
            bonus: Decimal.new("0")
          },
          %Coin{
            coin: "BIT",
            equity: Decimal.new("1.82"),
            usd_value: Decimal.new("0.48758257"),
            wallet_balance: Decimal.new("1.82"),
            available_to_withdraw: Decimal.new("1.82"),
            available_to_borrow: Decimal.new("0"),
            borrow_amount: Decimal.new("0"),
            accrued_interest: nil,
            total_order_im: Decimal.new("0"),
            total_position_im: Decimal.new("0"),
            total_position_mm: Decimal.new("0"),
            unrealised_pnl: Decimal.new("0"),
            cum_realised_pnl: Decimal.new("0"),
            bonus: Decimal.new("0")
          }
        ]
      }

      assert expected ==
        json_fixture("bybit/events/wallet_event")
        |> WalletEvent.from!()
    end
  end

  describe "GreekEvent" do
    alias ExchangeZoo.Bybit.Model.GreekEvent

    test "should parse a greek event" do
      expected = %GreekEvent{
        base_coin: "ETH",
        total_delta: Decimal.new("0.06999986"),
        total_gamma: Decimal.new("-0.00000001"),
        total_vega: Decimal.new("-0.00000024"),
        total_theta: Decimal.new("0.00001314")
      }

      assert expected ==
        json_fixture("bybit/events/greek_event")
        |> GreekEvent.from!()
    end
  end
end
