defmodule ExchangeZoo.BinanceUS.WS do
  @moduledoc ~S"""
  Source: https://docs.binance.us/#general-websocket-api-information
  """

  use Wind.Client, ping_timer: 30_000

  alias ExchangeZoo.BinanceUS.Model.BookTickerEvent

  require Logger

  @base_url "wss://stream.binance.us:9443/ws"

  def connect_uri(), do: URI.new!(@base_url)

  # [params, listen_key, callback_mod]
  def start_link(opts) do
    opts = Keyword.merge([uri: connect_uri()], opts)
    Wind.Client.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_connect(state) do
    params = state.opts[:params]
    message = Jason.encode!(%{method: "SUBSCRIBE", params: params, id: 1})

    {:reply, {:text, message}, state}
  end

  @impl true
  def handle_frame({:text, data}, state) do
    {:ok, data} = Jason.decode(data)

    {:ok, callback_state} =
      case parse_event(data) do
        # TODO: Pass error messages too (we'll need them in the UI)
        :subscribed ->
          {:ok, state.opts[:callback_state]}

        event ->
          state.opts[:callback_mod].handle_event({:event, event}, state.opts[:callback_state])
      end

    {:noreply, put_in(state[:opts][:callback_state], callback_state)}
  end

  def parse_event(%{"id" => 1, "result" => nil}), do: :subscribed

  # This one doesn't have an event identifier (so dumb)
  def parse_event(%{"A" => _, "B" => _, "a" => _, "b" => _, "s" => _, "u" => _} = data),
    do: BookTickerEvent.from!(data)
end
