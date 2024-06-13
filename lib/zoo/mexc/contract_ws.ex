defmodule ExchangeZoo.MEXC.ContractWS do
  @moduledoc ~S"""
  Source: https://mexcdevelop.github.io/apidocs/contract_v1_en/#websocket-api
  """

  use Wind.Client, ping_timer: 10_000, ping_frame: {:text, ~S[{"method": "ping"}]}

  alias ExchangeZoo.MEXC.Model.{AssetEvent, PositionEvent, OrderEvent}

  require Logger

  @base_url "wss://contract.mexc.com/edge"

  def connect_uri(), do: URI.new!(@base_url)

  def start_link(opts) do
    opts = Keyword.merge([uri: connect_uri()], opts)
    Wind.Client.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_connect(state) do
    api_key = Keyword.fetch!(state.opts, :api_key)
    secret_key = Keyword.fetch!(state.opts, :secret_key)

    timestamp =
      Keyword.get(state.opts, :timestamp, DateTime.utc_now() |> DateTime.to_unix(:millisecond))

    signature = ExchangeZoo.Request.sign_payload("#{api_key}#{timestamp}", secret_key)

    params = %{
      "apiKey" => api_key,
      "reqTime" => timestamp,
      "signature" => signature
    }

    message = Jason.encode!(%{method: "login", subscribe: false, param: params})

    {:reply, {:text, message}, state}
  end

  @impl true
  def handle_frame({:text, data}, state) do
    {:ok, data} = Jason.decode(data)

    {:ok, callback_state} =
      case parse_event(data) do
        :logged_in ->
          Logger.debug("Logged-in")
          apply_subscription_filter()
          {:ok, state.opts[:callback_state]}

        :subscribed_personal ->
          Logger.debug("Subscribed personal channel")
          {:ok, state.opts[:callback_state]}

        :pong ->
          {:ok, state.opts[:callback_state]}

        {:error, reason} ->
          state.opts[:callback_mod].handle_event({:error, reason}, state.opts[:callback_state])

        event ->
          state.opts[:callback_mod].handle_event({:event, event}, state.opts[:callback_state])
      end

    {:noreply, put_in(state[:opts][:callback_state], callback_state)}
  end

  defp apply_subscription_filter() do
    message =
      Jason.encode!(%{
        method: "personal.filter",
        param: %{filters: [%{filter: "asset"}]}
      })

    Wind.Client.send(self(), {:text, message})
  end

  def parse_event(%{"channel" => "rs.login", "data" => "success"}), do: :logged_in

  def parse_event(%{"channel" => "rs.error", "data" => reason}), do: {:error, reason}

  def parse_event(%{"channel" => "rs.personal.filter", "data" => "success"}), do: :subscribed_personal

  # def parse_event(%{"channel" => "clientId", "data" => _client_id}), do: :subscribed

  def parse_event(%{"channel" => "pong"}) do
    Process.send_after(self(), :ping_timer, 10_000)
    :pong
  end

  def parse_event(%{"channel" => "push.personal.asset", "data" => data}),
    do: AssetEvent.from!(data)

  def parse_event(%{"channel" => "push.personal.order", "data" => data}),
    do: OrderEvent.from!(data)

  def parse_event(%{"channel" => "push.personal.position", "data" => data}),
    do: PositionEvent.from!(data)
end
