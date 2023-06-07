defmodule ExchangeZoo.Binance.FAPI do
  use ExchangeZoo.API, base_url: "https://fapi.binance.com"

  import ExchangeZoo.Binance.Request

  alias ExchangeZoo.Binance.Model

  def get_exchange_info(opts \\ []) do
    build_url!("/fapi/v1/exchangeInfo", opts)
    |> perform_public(:get, Model.ExchangeInfo)
  end

  public :get, "/fapi/v1/assetIndex", Model.AssetIndex
  private :get, "/fapi/v1/leverageBracket", Model.LeverageBracket
  private :get, "/fapi/v1/ticker/bookTicker", Model.BookTicker, as: :order_book_ticker
  private :get, "/fapi/v2/account", Model.Account
  private :get, "/fapi/v1/openOrders", Model.Order
  private :post, "/fapi/v1/order", Model.Order
  private :post, "/fapi/v1/batchOrders", Model.Order
  private :delete, "/fapi/v1/order", Model.Order, as: :cancel_order
  private :delete, "/fapi/v1/allOpenOrders", nil, as: :cancel_all_open_orders
  private :delete, "/fapi/v1/batchOrders", Model.Order, as: :cancel_multiple_orders
  private :post, "/fapi/v1/listenKey", Model.ListenKey, as: :start_user_data_stream
  private :put, "/fapi/v1/listenKey", nil, as: :keepalive_user_data_stream
  private :delete, "/fapi/v1/listenKey", nil, as: :close_user_data_stream
  private :post, "/fapi/v1/leverage", nil, as: :change_initial_leverage
end
