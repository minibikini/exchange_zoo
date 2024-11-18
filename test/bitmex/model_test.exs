defmodule ExchangeZoo.BitMEX.ModelTest do
  use ExUnit.Case, async: true
  import ExchangeZoo.Fixtures

  describe "Stats" do
    alias ExchangeZoo.BitMEX.Model.Stats

    test "should parse /v1/stats" do
      expected = [
        %Stats{
          currency: "USDt",
          open_interest: 234_420_000,
          open_value: 9_357_110_105_520,
          root_symbol: "XBT",
          turnover24h: 21_325_658_792_000,
          volume24h: 534_668_000
        },
        %Stats{
          open_interest: 0,
          open_value: 0,
          root_symbol: "XBT",
          turnover24h: 25_339_700_950,
          volume24h: 63_490_000
        }
      ]

      assert expected ==
               json_fixture("bitmex/api_v1_stats")
               |> Enum.map(&Stats.from!/1)
    end
  end

  describe "WalletAsset" do
    alias ExchangeZoo.BitMEX.Model.WalletAsset
    alias ExchangeZoo.BitMEX.Model.WalletAsset.Network

    test "should parse /v1/wallet/assets" do
      expected = [
        %WalletAsset{
          asset: "XBT",
          currency: "XBt",
          major_currency: "XBT",
          name: "Bitcoin",
          currency_type: "Crypto",
          scale: 8,
          enabled: true,
          is_margin_currency: true,
          networks: [
            %Network{
              asset: "BTC",
              token_address: nil,
              deposit_enabled: true,
              withdrawal_enabled: true,
              withdrawal_fee: 0,
              min_fee: 0,
              max_fee: 0
            }
          ]
        }
      ]

      assert expected ==
               json_fixture("bitmex/api_v1_wallet_assets")
               |> Enum.map(&WalletAsset.from!/1)
    end
  end

  describe "WalletNetwork" do
    alias ExchangeZoo.BitMEX.Model.WalletNetwork

    test "should parse /v1/wallet/networks" do
      expected = [
        %WalletNetwork{
          network: "eth",
          name: "Ethereum",
          currency: "Gwei",
          network_symbol: "ETH",
          transaction_explorer: "https://etherscan.io/tx/",
          token_explorer: "https://etherscan.io/token/",
          deposit_confirmations: 0,
          enabled: true
        }
      ]

      assert expected ==
               json_fixture("bitmex/api_v1_wallet_networks")
               |> Enum.map(&WalletNetwork.from!/1)
    end
  end

  describe "User" do
    alias ExchangeZoo.BitMEX.Model.User

    test "should parse /v1/user" do
      expected = %User{
        id: 0,
        firstname: "string",
        lastname: "string",
        username: "string",
        account_name: "string",
        is_user: true,
        email: "string",
        date_of_birth: "string",
        phone: "string",
        created: ~U[2024-05-22T00:05:38.344000Z],
        last_updated: ~U[2024-05-22T00:05:38.344000Z],
        preferences: %User.Preferences{
          alert_on_liquidations: true,
          animations_enabled: true,
          announcements_last_seen: ~U[2024-05-22T00:05:38.344000Z],
          chat_channel_id: 0,
          color_theme: "string",
          currency: "string",
          debug: true,
          disable_emails: ["string"],
          disable_push: ["string"],
          display_corp_enroll_upsell: true,
          equivalent_currency: "string",
          features: ["string"],
          favourites: ["string"],
          favourites_assets: ["string"],
          favourites_ordered: ["string"],
          favourite_bots: ["string"],
          has_set_trading_currencies: true,
          hide_confirm_dialogs: ["string"],
          hide_connection_modal: true,
          hide_from_leaderboard: false,
          hide_name_from_leaderboard: true,
          hide_pnl_in_guilds: false,
          hide_roi_in_guilds: false,
          hide_notifications: ["string"],
          hide_phone_confirm: false,
          is_sensitive_info_visible: true,
          is_wallet_zero_balance_hidden: true,
          locale: "en-US",
          locale_set_time: 0,
          margin_pnl_row: "string",
          margin_pnl_row_kind: "string",
          mobile_locale: "string",
          msgs_seen: ["string"],
          notifications: %{},
          options_beta: true,
          order_book_binning: %{},
          order_book_type: "string",
          order_clear_immediate: false,
          order_controls_plus_minus: true,
          platform_layout: "string",
          selected_fiat_currency: "string",
          show_chart_bottom_toolbar: true,
          show_locale_numbers: true,
          sounds: ["string"],
          spacing_preference: "string",
          strict_ip_check: false,
          strict_timeout: true,
          ticker_group: "string",
          ticker_pinned: true,
          trade_layout: "string",
          user_color: "string"
        },
        tfa_enabled: "string",
        affiliate_id: "string",
        country: "string",
        geoip_country: "string",
        geoip_region: "string",
        first_trade_timestamp: ~U[2024-05-22T00:05:38.344000Z],
        first_deposit_timestamp: ~U[2024-05-22T00:05:38.344000Z],
        typ: "string"
      }

      assert expected ==
               json_fixture("bitmex/api_v1_user")
               |> User.from!()
    end
  end

  describe "UserMargin" do
    alias ExchangeZoo.BitMEX.Model.UserMargin

    test "should parse /v1/user/margin" do
      expected = %UserMargin{
        account: 0,
        currency: "BTC",
        risk_limit: 0,
        state: "string",
        amount: 0,
        prev_realised_pnl: 0,
        gross_comm: 0,
        gross_open_cost: 0,
        gross_open_premium: 0,
        gross_exec_cost: 0,
        gross_mark_value: 0,
        risk_value: 0,
        init_margin: 0,
        maint_margin: 0,
        target_excess_margin: 0,
        realised_pnl: 0,
        unrealised_pnl: 0,
        wallet_balance: 0,
        margin_balance: 0,
        margin_leverage: 0,
        margin_used_pcnt: 0,
        excess_margin: 0,
        available_margin: 0,
        withdrawable_margin: 0,
        maker_fee_discount: 0,
        taker_fee_discount: 0,
        timestamp: ~U[2024-01-25T21:23:22.770000Z]
      }

      assert expected ==
               json_fixture("bitmex/api_v1_user_margin")
               |> UserMargin.from!()
    end
  end

  describe "Position" do
    alias ExchangeZoo.BitMEX.Model.Position

    test "should parse /v1/api_v1_position" do
      expected = [
        %Position{
          account: 0,
          symbol: "string",
          currency: "string",
          underlying: "string",
          quote_currency: "string",
          commission: 0,
          init_margin_req: 0,
          maint_margin_req: 0,
          risk_limit: 0,
          leverage: 0,
          cross_margin: true,
          deleverage_percentile: 0,
          rebalanced_pnl: 0,
          prev_realised_pnl: 0,
          prev_unrealised_pnl: 0,
          opening_qty: 0,
          open_order_buy_qty: 0,
          open_order_buy_cost: 0,
          open_order_buy_premium: 0,
          open_order_sell_qty: 0,
          open_order_sell_cost: 0,
          open_order_sell_premium: 0,
          current_qty: 0,
          current_cost: 0,
          current_comm: 0,
          realised_cost: 0,
          unrealised_cost: 0,
          gross_open_premium: 0,
          is_open: true,
          mark_price: 0,
          mark_value: 0,
          risk_value: 0,
          home_notional: 0,
          foreign_notional: 0,
          pos_state: "string",
          pos_cost: 0,
          pos_cross: 0,
          pos_comm: 0,
          pos_loss: 0,
          pos_margin: 0,
          pos_maint: 0,
          init_margin: 0,
          maint_margin: 0,
          realised_pnl: 0,
          unrealised_pnl: 0,
          unrealised_pnl_pcnt: 0,
          unrealised_roe_pcnt: 0,
          avg_cost_price: 0,
          avg_entry_price: 0,
          break_even_price: 0,
          margin_call_price: 0,
          liquidation_price: 0,
          bankrupt_price: 0,
          timestamp: ~U[2024-01-25T21:23:22.716000Z]
        }
      ]

      assert expected ==
               json_fixture("bitmex/api_v1_position")
               |> Enum.map(&Position.from!/1)
    end
  end

  describe "Order" do
    alias ExchangeZoo.BitMEX.Model.Order

    test "should parse /v1/api_v1_orders" do
      expected = [
        %Order{
          order_id: "string",
          cl_ord_id: "string",
          cl_ord_link_id: "string",
          account: 0,
          symbol: "string",
          side: "string",
          order_qty: 0,
          price: Decimal.new("0"),
          display_qty: 0,
          stop_px: Decimal.new("0"),
          peg_offset_value: Decimal.new("0"),
          peg_price_type: "string",
          currency: "string",
          settl_currency: "string",
          ord_type: "string",
          time_in_force: "string",
          exec_inst: "string",
          contingency_type: "string",
          ord_status: "string",
          triggered: "string",
          working_indicator: true,
          ord_rej_reason: "string",
          leaves_qty: 0,
          cum_qty: 0,
          avg_px: Decimal.new("0"),
          text: "string",
          transact_time: ~U[2024-01-25T21:23:22.696000Z],
          timestamp: ~U[2024-01-25T21:23:22.696000Z]
        }
      ]

      assert expected ==
               json_fixture("bitmex/api_v1_orders")
               |> Enum.map(&Order.from!/1)
    end
  end

  describe "InstrumentEvent" do
    alias ExchangeZoo.BitMEX.Model.InstrumentEvent

    test "should parse instrument event" do
      expected =
        %InstrumentEvent{
          symbol: "ADAUSD",
          open_value: 106_425_852,
          fair_price: Decimal.new("0.4849"),
          mark_price: Decimal.new("0.4849"),
          timestamp: ~U[2024-01-27T17:47:20.749000Z]
        }

      assert expected ==
               json_fixture("bitmex/events/instrument_event")
               |> InstrumentEvent.from!()
    end
  end

  describe "FundingEvent" do
    alias ExchangeZoo.BitMEX.Model.FundingEvent

    test "should parse funding event" do
      expected =
        %FundingEvent{
          symbol: "AXSUSD",
          funding_rate: Decimal.new("0.0001"),
          funding_rate_daily: Decimal.new("0.00030000000000000003"),
          funding_interval: ~U[2000-01-01T08:00:00.000000Z],
          timestamp: ~U[2024-01-27T12:00:00.000000Z]
        }

      assert expected ==
               json_fixture("bitmex/events/funding_event")
               |> FundingEvent.from!()
    end
  end

  describe "ExecutionEvent" do
    alias ExchangeZoo.BitMEX.Model.ExecutionEvent

    test "should parse execution event" do
      expected =
        %ExecutionEvent{
          exec_id: "0193e879-cb6f-2891-d099-2c4eb40fee21",
          order_id: "00000000-0000-0000-0000-000000000000",
          cl_ord_id: nil,
          cl_ord_link_id: nil,
          account: 2,
          symbol: "XBTUSD",
          side: "Sell",
          last_qty: 1,
          last_px: Decimal.new("1134.37"),
          underlying_last_px: nil,
          last_mkt: "XBME",
          last_liquidity_ind: "RemovedLiquidity",
          simple_order_qty: nil,
          order_qty: 1,
          price: Decimal.new("1134.37"),
          display_qty: nil,
          stop_px: nil,
          peg_offset_value: nil,
          peg_price_type: nil,
          currency: "USD",
          settl_currency: "XBt",
          exec_type: "Trade",
          ord_type: "Limit",
          time_in_force: "ImmediateOrCancel",
          exec_inst: nil,
          contingency_type: nil,
          ex_destination: "XBME",
          ord_status: "Filled",
          triggered: nil,
          working_indicator: false,
          ord_rej_reason: nil,
          simple_leaves_qty: 0,
          leaves_qty: 0,
          simple_cum_qty: Decimal.new("0.001"),
          cum_qty: 1,
          avg_px: Decimal.new("1134.37"),
          commission: Decimal.new("0.00075"),
          trade_publish_indicator: "DoNotPublishTrade",
          multi_leg_reporting_type: "SingleSecurity",
          text: "Liquidation",
          trd_match_id: "7f4ab7f6-0006-3234-76f4-ae1385aad00f",
          exec_cost: 88155,
          exec_comm: 66,
          home_notional: Decimal.new("-0.00088155"),
          foreign_notional: 1,
          transact_time: ~U[2017-04-04T22:07:46.035000Z],
          timestamp: ~U[2017-04-04T22:07:46.035000Z]
        }

      assert expected ==
               json_fixture("bitmex/events/execution_event")
               |> ExecutionEvent.from!()
    end
  end

  describe "MarginEvent" do
    alias ExchangeZoo.BitMEX.Model.MarginEvent

    test "should parse margin event" do
      expected =
        %MarginEvent{
          account: 413_794,
          currency: "XBt",
          risk_limit: 1_000_000_000_000,
          amount: 1_000_000,
          prev_realised_pnl: 0,
          gross_comm: 0,
          gross_open_cost: 0,
          gross_open_premium: 0,
          gross_exec_cost: 0,
          gross_mark_value: 0,
          risk_value: 0,
          init_margin: 0,
          maint_margin: 0,
          target_excess_margin: 0,
          realised_pnl: 0,
          unrealised_pnl: 0,
          wallet_balance: 1_000_000,
          margin_balance: 1_000_000,
          margin_leverage: Decimal.new("0.0"),
          margin_used_pcnt: Decimal.new("0.0"),
          excess_margin: 1_000_000,
          available_margin: 1_000_000,
          withdrawable_margin: 1_000_000,
          timestamp: ~U[2024-01-25T17:39:06.157000Z]
        }

      assert expected ==
               json_fixture("bitmex/events/margin_event")
               |> MarginEvent.from!()
    end
  end

  describe "WalletEvent" do
    alias ExchangeZoo.BitMEX.Model.WalletEvent

    test "should parse wallet event" do
      expected =
        %WalletEvent{
          account: 413_794,
          currency: "XBt",
          deposited: 0,
          withdrawn: 0,
          transferIn: nil,
          transferOut: nil,
          amount: 1_000_000,
          pendingCredit: nil,
          pendingDebit: nil,
          confirmedDebit: nil,
          timestamp: ~U[2024-01-25 17:39:06.157000Z]
        }

      assert expected ==
               json_fixture("bitmex/events/wallet_event")
               |> WalletEvent.from!()
    end
  end
end
