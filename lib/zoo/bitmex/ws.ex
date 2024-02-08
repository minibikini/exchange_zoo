defmodule ExchangeZoo.BitMEX.WS do
  @moduledoc ~S"""
  Source: https://www.bitmex.com/app/wsAPI
  """

  use Wind.Client, ping_timer: 30_000

  alias ExchangeZoo.Request

  alias ExchangeZoo.BitMEX.Model.{
    ExecutionEvent,
    FundingEvent,
    InstrumentEvent,
    MarginEvent,
    Position,
    Order,
    WalletEvent
  }

  require Logger

  @base_url "wss://ws.testnet.bitmex.com/realtime"

  def connect_uri(), do: URI.new!(@base_url)

  # [api_key, secret_key, callback_mod]
  def start_link(opts) do
    opts = Keyword.merge([uri: connect_uri()], opts)
    Wind.Client.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_connect(state) do
    {:reply, {:text, authenticate_message(state.opts)}, state}
  end

  defp authenticate_message(opts) do
    api_key = Keyword.fetch!(opts, :api_key)
    secret_key = Keyword.fetch!(opts, :secret_key)

    timestamp =
      Keyword.get(opts, :timestamp, DateTime.utc_now() |> DateTime.to_unix(:millisecond))

    recv_window = Keyword.get(opts, :recv_window, 5000)
    expires = ceil((timestamp + recv_window) / 1000)
    payload = "GET/realtime#{expires}"
    signature = Request.sign_payload(payload, secret_key)

    Jason.encode!(%{op: "authKeyExpires", args: [api_key, expires, signature]})
  end

  defp subscribe_message(_opts) do
    subscription_topics =
      ~w(funding instrument margin wallet execution order position)

    Jason.encode!(%{op: "subscribe", args: subscription_topics})
  end

  @impl true
  def handle_frame({:text, data}, state) do
    # IO.puts(data)
    # {:ok, data} = Jason.decode(data)
    # dbg(data, limit: :infinity)

    case parse_event(data) do
      :preamble ->
        {:noreply, state}

      :authenticated ->
        message = subscribe_message(state.opts)
        {:reply, {:text, message}, state}

      :subscribed ->
        {:noreply, state}

      # TODO: Pass error messages too (we'll need them in the UI)
      event ->
        callback_state =
          state.opts[:callback_mod].handle_event({:event, event}, state.opts[:callback_state])

        {:noreply, put_in(state[:opts][:callback_state], callback_state)}
    end
  end

  def parse_event(%{"info" => "Welcome" <> _}), do: :preamble

  def parse_event(%{"request" => %{"op" => "authKeyExpires"}, "success" => true}),
    do: :authenticated

  def parse_event(%{"request" => %{"op" => "subscribe"}, "success" => true}), do: :subscribed

  def parse_event(%{"table" => "execution", "data" => data}),
    do: Enum.map(data, &ExecutionEvent.from!/1)

  def parse_event(%{"table" => "funding", "data" => data}),
    do: Enum.map(data, &FundingEvent.from!/1)

  def parse_event(%{"table" => "instrument", "data" => data}),
    do: Enum.map(data, &InstrumentEvent.from!/1)

  def parse_event(%{"table" => "position", "data" => data}),
    do: Enum.map(data, &Position.from!/1)

  def parse_event(%{"table" => "order", "data" => data}),
    do: Enum.map(data, &Order.from!/1)

  def parse_event(%{"table" => "margin", "data" => data}),
    do: Enum.map(data, &MarginEvent.from!/1)

  def parse_event(%{"table" => "wallet", "data" => data}),
    do: Enum.map(data, &WalletEvent.from!/1)

  # def parse_event(m), do: dbg(m)
end
