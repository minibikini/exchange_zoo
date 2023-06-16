defmodule ExchangeZoo.Binance.FWSTest do
  use ExUnit.Case, async: true
  # import ExchangeZoo.Fixtures

  alias ExchangeZoo.Binance

  @api_key System.fetch_env!("BINANCE_FUTURES_API_KEY")
  @secret_key System.fetch_env!("BINANCE_FUTURES_API_SECRET")

  @rest_uri "https://testnet.binancefuture.com"
  @ws_uri "wss://stream.binancefuture.com/ws"

  @tag :external
  describe "with an active connection" do
    setup do
      {:ok, %Binance.Model.ListenKey{listen_key: listen_key}} =
        Binance.FAPI.start_user_data_stream([],
          uri: @rest_uri,
          api_key: @api_key,
          secret_key: @secret_key
        )

      %{listen_key: listen_key}
    end

    test "start_link/1", %{listen_key: listen_key} do
      assert {:ok, _pid} =
               Binance.FWS.start_link(
                 uri: URI.new!(@ws_uri),
                 listen_key: listen_key,
                 params: ["!assetIndex@arr"],
                 callback_mod: Test,
                 callback_state: %{parent: self()}
               )

      # !assetIndex@arr updates 1/s
      assert_receive {:event, _data}, 30000
    end
  end
end

defmodule Test do
  def handle_event(message, state) do
    send(state.parent, message)
    {:ok, state}
  end
end
