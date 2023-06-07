defmodule ExchangeZoo.Bybit.API do
  use ExchangeZoo.API, base_url: "https://api-testnet.bybit.com"

  import ExchangeZoo.Bybit.Request

  alias ExchangeZoo.Bybit.Model

  public :get, "/v5/market/instruments-info", Model.InstrumentsInfo
end
