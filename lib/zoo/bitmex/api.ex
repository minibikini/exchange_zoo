defmodule ExchangeZoo.BitMEX.API do
  use ExchangeZoo.API, base_url: "https://testnet.bitmex.com/api/v1"

  alias ExchangeZoo.BitMEX.Model

  public :get, "/stats", Model.Stats
  private :get, "/order", Model.Order
  private :get, "/position", Model.Position
  private :get, "/wallet/assets", Model.WalletAsset
  private :get, "/wallet/networks", Model.WalletNetwork
  private :get, "/user/margin", Model.UserMargin
end
