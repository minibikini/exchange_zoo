defmodule ExchangeZoo.MEXC.SpotAPI do
  use ExchangeZoo.API,
    base_url: "https://api.mexc.com/api/v3",
    request_module: ExchangeZoo.MEXC.SpotRequest

  alias ExchangeZoo.MEXC.Model

  public :get, "/exchangeInfo", Model.ExchangeInfo
end
