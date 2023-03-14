defmodule ExchangeZoo.API.Binance.FAPI do
  alias ExchangeZoo.Request
  alias ExchangeZoo.Binance.Model.{Account, Order}

  @base_url "https://testnet.binancefuture.com/fapi"
  # @base_url "https://fapi.binance.com"

  def get_account(opts \\ []) do
    build_url!("/v2/account")
    |> append_query_params(opts)
    |> perform_private(:get, Account)
  end

  def get_open_orders(opts \\ []) do
    build_url!("/v1/openOrders")
    |> append_query_params(opts)
    |> perform_private(:get, Order)
  end

  def create_order(opts \\ []) do
    build_url!("/v1/order")
    |> append_query_params(opts)
    |> perform_private(:post, Order)
  end

  def cancel_order(opts \\ []) do
    build_url!("/v1/order")
    |> append_query_params(opts)
    |> perform_private(:delete, Order)
  end

  def cancel_all_open_orders(opts \\ []) do
    build_url!("/v1/allOpenOrders")
    |> append_query_params(opts)
    |> perform_private(:delete)
  end

  def cancel_multiple_orders(opts \\ []) do
    build_url!("/v1/batchOrders")
    |> append_query_params(opts)
    |> perform_private(:delete, Order)
  end

  def start_user_data_stream(opts \\ []) do
    build_url!("/v1/listenKey")
    |> append_query_params(opts)
    |> perform_private(:post)
  end

  def keepalive_user_data_stream(opts \\ []) do
    build_url!("/v1/listenKey")
    |> append_query_params(opts)
    |> perform_private(:put)
  end

  def close_user_data_stream(opts \\ []) do
    build_url!("/v1/listenKey")
    |> append_query_params(opts)
    |> perform_private(:delete)
  end

  defp build_url!(path), do: URI.new!(@base_url <> path)

  defp perform_private(url, method, mod \\ nil, opts \\ []) do
    api_key = Keyword.get(opts, :api_key, get_api_key())
    secret_key = Keyword.get(opts, :secret_key, get_secret_key())

    Finch.build(method, url)
    |> Request.add_header("X-MBX-APIKEY", api_key)
    |> Request.put_signature(secret_key)
    |> Request.perform(mod)
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
