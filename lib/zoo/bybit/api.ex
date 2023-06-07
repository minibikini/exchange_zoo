defmodule ExchangeZoo.Bybit.API do
  use ExchangeZoo.API, base_url: "https://api-testnet.bybit.com"

  alias ExchangeZoo.Bybit.Model

  public :get, "/v5/market/instruments-info", Model.InstrumentsInfo
  private :post, "/v5/order/create", Model.OrderResponse, as: :create_order
end
