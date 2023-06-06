defmodule ExchangeZoo.Bybit.API do
  import ExchangeZoo.Bybit.Request
  alias ExchangeZoo.Bybit.Model.InstrumentsInfo

  @base_url "https://api-testnet.bybit.com"

  def get_instruments_info(params \\ [], opts \\ []) do
    build_url!("/v5/market/instruments-info", opts)
    |> append_query_params(params)
    |> perform_public(:get, InstrumentsInfo)
  end

  defp build_url!(path, opts) do
    opts = Keyword.merge([uri: @base_url], opts)
    URI.new!(opts[:uri] <> path)
  end

  defp append_query_params(%URI{} = uri, opts) do
    URI.append_query(uri, URI.encode_query(opts))
  end
end
