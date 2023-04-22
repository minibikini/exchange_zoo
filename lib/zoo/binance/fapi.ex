defmodule ExchangeZoo.Binance.FAPI do
  alias ExchangeZoo.Request
  alias ExchangeZoo.Binance.Model.{ExchangeInfo, LeverageBracket, Account, Order, ListenKey, Error}

  @base_url "https://testnet.binancefuture.com"
  # @base_url "https://fapi.binance.com"

  def get_exchange_info(opts \\ []) do
    build_url!("/fapi/v1/exchangeInfo", opts)
    |> perform_public(:get, ExchangeInfo)
  end

  def get_leverage_bracket(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/leverageBracket", opts)
    |> append_query_params(params)
    |> perform_private(:get, LeverageBracket, opts)
  end

  def get_account(params \\ [], opts \\ []) do
    build_url!("/fapi/v2/account", opts)
    |> append_query_params(params)
    |> perform_private(:get, Account, opts)
  end

  def get_open_orders(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/openOrders", opts)
    |> append_query_params(params)
    |> perform_private(:get, Order, opts)
  end

  def create_order(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/order", opts)
    |> append_query_params(params)
    |> perform_private(:post, Order, opts)
  end

  def cancel_order(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/order", opts)
    |> append_query_params(params)
    |> perform_private(:delete, Order, opts)
  end

  def cancel_all_open_orders(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/allOpenOrders", opts)
    |> append_query_params(params)
    |> perform_private(:delete, opts)
  end

  def cancel_multiple_orders(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/batchOrders", opts)
    |> append_query_params(params)
    |> perform_private(:delete, Order, opts)
  end

  def start_user_data_stream(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/listenKey", opts)
    |> append_query_params(params)
    |> perform_private(:post, ListenKey, opts)
  end

  def keepalive_user_data_stream(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/listenKey", opts)
    |> append_query_params(params)
    |> perform_private(:put, nil, opts)
  end

  def close_user_data_stream(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/listenKey", opts)
    |> append_query_params(params)
    |> perform_private(:delete, nil, opts)
  end

  def change_initial_leverage(params \\ [], opts \\ []) do
    build_url!("/fapi/v1/leverage", opts)
    |> append_query_params(params)
    |> perform_private(:post, nil, opts)
  end

  defp build_url!(path, opts) do
    opts = Keyword.merge([uri: @base_url], opts)
    URI.new!(opts[:uri] <> path)
  end

  defp perform_public(url, method, mod) do
    Finch.build(method, url)
    |> Request.perform(mod)
  end

  defp perform_private(url, method, mod, opts \\ []) do
    api_key = Keyword.get(opts, :api_key, get_api_key())
    secret_key = Keyword.get(opts, :secret_key, get_secret_key())

    Finch.build(method, url)
    |> Request.add_header("X-MBX-APIKEY", api_key)
    |> Request.put_signature(secret_key)
    |> Request.perform(mod, Error)
  end

  defp get_api_key() do
    System.get_env("BINANCE_FUTURES_API_KEY")
  end

  defp get_secret_key() do
    System.get_env("BINANCE_FUTURES_API_SECRET")
  end

  defp append_query_params(%URI{} = uri, opts) do
    now = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    opts = Keyword.put_new(opts, :timestamp, now)

    URI.append_query(uri, URI.encode_query(opts))
  end
end
