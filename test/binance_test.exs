defmodule ExchangeZoo.BinanceTest do
  use ExUnit.Case, async: true
  import ExchangeZoo.Fixtures

  describe "account_info" do
    alias ExchangeZoo.Binance.Model.Account

    test "should parse /fapi/v2/account" do
      record =
        json_fixture("binance/fapi_v2_account")
        |> Account.from!()

      assert record.available_balance == Decimal.new("126.72469206")
    end
  end

  describe "order" do
    alias ExchangeZoo.Binance.Model.Order

    test "should parse /fapi/v1/openOrders" do
      [record] =
        json_fixture("binance/fapi_v1_openOrders")
        |> Enum.map(&Order.from!/1)

      assert record.order_id == 1917641
    end
  end
end
