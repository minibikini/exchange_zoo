defmodule Zoo.BinanceTest do
  use ExUnit.Case, async: true
  import Zoo.Fixtures

  describe "FAPI" do
    alias Zoo.API.Binance.FAPI

    @doc """
    Source: https://binance-docs.github.io/apidocs/futures/en/#signed-trade-and-user_data-endpoint-security
    """
    test "should sign request" do
      url = "https://fapi/binance.com/fapi/v1/order?symbol=BTCUSDT&side=BUY&type=LIMIT&quantity=1&price=9000&timeInForce=GTC&recvWindow=5000&timestamp=1591702613943"
      request =
        Finch.build(:get, url)
        |> FAPI.put_api_key("dbefbc809e3e83c283a984c3a1459732ea7db1360ca80c5c2c8867408d28cc83")
        |> FAPI.put_signature("2b5eb11e18796d12d88f13dc27dbbd02c2cc51ff7059765ed9821957d82bb4d9")

      assert [{"X-MBX-APIKEY", "dbefbc809e3e83c283a984c3a1459732ea7db1360ca80c5c2c8867408d28cc83"}] = request.headers
      assert String.ends_with?(request.query, "&signature=3c661234138461fcc7a7d8746c6558c9842d4e10870d2ecbedf7777cad694af9")
    end
  end

  describe "account_info" do
    alias Zoo.Binance.Model.AccountInfo

    test "should parse /fapi/v2/account" do
      record =
        json_fixture("binance/fapi_v2_account")
        |> AccountInfo.from!()

      assert record.available_balance == Decimal.new("126.72469206")
    end
  end

  describe "order" do
    alias Zoo.Binance.Model.Order

    test "should parse /fapi/v1/openOrders" do
      [record] =
        json_fixture("binance/fapi_v1_openOrders")
        |> Enum.map(&Order.from!/1)

      assert record.order_id == 1917641
    end
  end
end
