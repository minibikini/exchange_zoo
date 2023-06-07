defmodule ExchangeZoo.Binance.FAPI do
  use ExchangeZoo.API, base_url: "https://fapi.binance.com"

  import ExchangeZoo.Binance.Request

  alias ExchangeZoo.Binance.Model

  def get_exchange_info(opts \\ []) do
    build_url!("/fapi/v1/exchangeInfo", opts)
    |> perform_public(:get, Model.ExchangeInfo)
  end

  endpoint :get, "/fapi/v1/assetIndex", Model.AssetIndex
  endpoint :get, "/fapi/v1/leverageBracket", Model.LeverageBracket
  endpoint :get, "/fapi/v1/ticker/bookTicker", Model.BookTicker, as: :get_order_book_ticker
  endpoint :get, "/fapi/v2/account", Model.Account
  endpoint :get, "/fapi/v1/openOrders", Model.Order
  endpoint :post, "/fapi/v1/order", Model.Order
  endpoint :post, "/fapi/v1/batchOrders", Model.Order
  endpoint :delete, "/fapi/v1/order", Model.Order, as: :cancel_order
  endpoint :delete, "/fapi/v1/allOpenOrders", nil, as: :cancel_all_open_orders
  endpoint :delete, "/fapi/v1/batchOrders", Model.Order, as: :cancel_multiple_orders
  endpoint :post, "/fapi/v1/listenKey", Model.ListenKey, as: :start_user_data_stream
  endpoint :put, "/fapi/v1/listenKey", nil, as: :keepalive_user_data_stream
  endpoint :delete, "/fapi/v1/listenKey", nil, as: :close_user_data_stream
  endpoint :post, "/fapi/v1/leverage", nil, as: :change_initial_leverage
end
