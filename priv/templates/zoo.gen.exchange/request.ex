defmodule ExchangeZoo.<%= @exchange.name %>.Request do
  alias ExchangeZoo.Request
  alias ExchangeZoo.<%= @exchange.name %>.Model.Error

  def perform_public(url, method, params, mod) do
    url = append_query_params(url, params)

    Finch.build(method, url)
    |> Request.perform(mod, Error)
  end

  def perform_private(url, method, params, mod, opts) do
    # TODO: Implement me
    raise "Not yet implemented"
  end

  defdelegate append_query_params(uri, opts), to: Request
end
