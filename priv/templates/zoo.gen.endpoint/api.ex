defmodule ExchangeZoo.<%= @exchange.name %>.API do
  use ExchangeZoo.API, base_url: @api.base_url
  import ExchangeZoo.<%= @exchange.name %>.Request

  alias ExchangeZoo.<%= @exchange.name %>.Model

end
