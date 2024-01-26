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
          price: 0,
          display_qty: 0,
          stop_px: 0,
          peg_offset_value: 0,
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
          avg_px: 0,
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
end
