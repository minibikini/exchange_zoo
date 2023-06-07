defmodule ExchangeZoo.Bybit.API do
  use ExchangeZoo.API, base_url: "https://api-testnet.bybit.com"

  import ExchangeZoo.Bybit.Request

  alias ExchangeZoo.Bybit.Model

  endpoint :get, "/v5/market/instruments-info", Model.InstrumentsInfo
end
