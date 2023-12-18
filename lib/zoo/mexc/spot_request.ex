defmodule ExchangeZoo.MEXC.SpotRequest do
  alias ExchangeZoo.Request
  alias ExchangeZoo.MEXC.Model.SpotError

  def perform_public(url, method, params, mod) do
    url = append_query_params(url, params)

    Finch.build(method, url)
    |> Request.perform(mod, SpotError)
  end

  def perform_private(url, method, mod, opts) do
    # TODO: Implement me
    raise "Not yet implemented"
  end

  defdelegate append_query_params(uri, opts), to: Request
end
