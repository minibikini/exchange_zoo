defmodule ExchangeZoo.RequestTest do
  use ExUnit.Case, async: true
  alias ExchangeZoo.Request

  @doc """
  Source: https://binance-docs.github.io/apidocs/futures/en/#signed-trade-and-user_data-endpoint-security
  """
  test "should sign request" do
    url = "https://fapi.binance.com/fapi/v1/order?symbol=BTCUSDT&side=BUY&type=LIMIT&quantity=1&price=9000&timeInForce=GTC&recvWindow=5000&timestamp=1591702613943"
    request =
      Finch.build(:get, url)
      |> Request.add_header("X-MBX-APIKEY", "dbefbc809e3e83c283a984c3a1459732ea7db1360ca80c5c2c8867408d28cc83")
      |> Request.put_signature("2b5eb11e18796d12d88f13dc27dbbd02c2cc51ff7059765ed9821957d82bb4d9")

    assert [{"X-MBX-APIKEY", "dbefbc809e3e83c283a984c3a1459732ea7db1360ca80c5c2c8867408d28cc83"}] = request.headers
    assert String.ends_with?(request.query, "&signature=3c661234138461fcc7a7d8746c6558c9842d4e10870d2ecbedf7777cad694af9")
  end
end
