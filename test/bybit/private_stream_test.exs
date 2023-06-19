defmodule ExchangeZoo.Bybit.PrivateStreamTest do
  use ExUnit.Case, async: true
  # import ExchangeZoo.Fixtures

  alias ExchangeZoo.Bybit

  @api_key System.fetch_env!("BYBIT_API_KEY")
  @secret_key System.fetch_env!("BYBIT_API_SECRET")

  # @rest_uri "bybit.com"
  @ws_uri "wss://stream-testnet.bybit.com/v5/private"

  describe "with an active connection" do
    @describetag :external

    defmodule Test do
      def handle_event(message, state) do
        send(state.parent, message)
        {:ok, state}
      end
    end

    test "start_link/1" do
      assert {:ok, _pid} =
               Bybit.PrivateStream.start_link(
                 uri: URI.new!(@ws_uri),
                 api_key: @api_key,
                 secret_key: @secret_key,
                 params: ["execution", "position", "order", "wallet", "greeks"],
                 callback_mod: Test,
                 callback_state: %{parent: self()}
               )

      assert_receive {:event, _data}, 30000
    end
  end
end
