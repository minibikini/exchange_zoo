defmodule ExchangeZoo.MEXC.ContractAPI do
  use ExchangeZoo.API,
    base_url: "https://contract.mexc.com/api/v1",
    request_module: ExchangeZoo.MEXC.ContractRequest

  alias ExchangeZoo.MEXC.Model

  public :get, "/contract/detail", Model.ContractDetail
  private :get, "/private/account/assets", Model.AccountAsset
  private :get, "/private/position/leverage", Model.Leverage
  private :get, "/private/order/list/open_orders", Model.Order
  private :post, "/private/position/change_leverage", nil, as: :change_leverage
  private :post, "/private/order/submit", nil, as: :create_order
  private :post, "/private/order/submit_batch", nil, as: :create_batch_order
  private :post, "/private/order/cancel", nil, as: :cancel_order
  private :post, "/private/order/cancel_with_external", nil, as: :cancel_orders_with_external
  private :post, "/private/order/cancel_all", nil, as: :cancel_all_orders
end
