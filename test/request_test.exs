defmodule ExchangeZoo.RequestTest do
  use ExUnit.Case, async: true
  alias ExchangeZoo.Request

  @api_key "dbefbc809e3e83c283a984c3a1459732ea7db1360ca80c5c2c8867408d28cc83"
  @secret_key "2b5eb11e18796d12d88f13dc27dbbd02c2cc51ff7059765ed9821957d82bb4d9"

  @doc """
  Source: https://bybit-exchange.github.io/docs/v5/guide#select-your-api-key-type
  """
  test "should sign request with header signature" do
    url =
      "https://api-testnet.bybit.com/v5/order/realtime?category=option&symbol=BTC-29JUL22-25000-C"

    request =
      Finch.build(:get, url)
      |> Request.add_header("X-BAPI-API-KEY", @api_key)
      |> Request.put_header_signature("signature", @secret_key)

    assert [
             {"signature", "7dbc771820ae7ca8ba074a322d7874842dde1f7e9a1710e0a8df4ca7679abd36"},
             {"X-BAPI-API-KEY", @api_key}
           ] = request.headers
  end

  @doc """
  Source: https://binance-docs.github.io/apidocs/futures/en/#signed-trade-and-user_data-endpoint-security
  """
  test "should sign request with query param signature" do
    url =
      "https://fapi.binance.com/fapi/v1/order?symbol=BTCUSDT&side=BUY&type=LIMIT&quantity=1&price=9000&timeInForce=GTC&recvWindow=5000&timestamp=1591702613943"

    request =
      Finch.build(:get, url)
      |> Request.add_header("X-MBX-APIKEY", @api_key)
      |> Request.put_query_signature("signature", @secret_key)

    assert [{"X-MBX-APIKEY", @api_key}] = request.headers

    assert String.ends_with?(
             request.query,
             "&signature=3c661234138461fcc7a7d8746c6558c9842d4e10870d2ecbedf7777cad694af9"
           )
  end
end
