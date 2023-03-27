defmodule ExchangeZoo.Binance.Model.OrderTradeUpdateEvent do
  use ExchangeZoo.Model
  alias ExchangeZoo.Binance.Model.OrderTradeUpdateEvent.OrderUpdate

  @primary_key false

  @fields %{
    "E" => :event_time,
    "T" => :transaction_time,
    "o" => :order_update
  }

  embedded_schema do
    field :event_time, :integer
    field :transaction_time, :integer

    embeds_one :order_update, OrderUpdate
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)

    event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:order_update])
    |> cast_embed(:order_update)
  end
end

defmodule ExchangeZoo.Binance.Model.OrderTradeUpdateEvent.OrderUpdate do
  use ExchangeZoo.Model

  @primary_key false

  @order_types ~w(limit market stop stop_market take_profit take_profit_market trailing_stop_market)a
  @order_sides ~w(buy sell)a
  @order_statuses ~w(new partially_filled filled canceled rejected expired)a
  @position_sides ~w(both long short)a
  @time_in_forces ~w(gtc ioc fok gtx)a
  @execution_types ~w(new canceled calculated expired trade)a
  @working_types ~w(mark_price contract_price)a

  @fields %{
    "s" => :symbol,
    "c" => :client_order_id,
    "S" => :side,
    "o" => :order_type,
    "f" => :time_in_force,
    "q" => :original_quantity,
    "p" => :original_price,
    "ap" => :avg_price,
    "sp" => :stop_price,
    "x" => :execution_type,
    "X" => :order_status,
    "i" => :order_id,
    "l" => :order_last_filled_qty,
    "z" => :total_filled,
    "L" => :last_fill_price,
    "N" => :commission_asset,
    "n" => :commission_amount,
    "T" => :order_trade_time,
    "t" => :trade_id,
    "b" => :bid_notional,
    "a" => :ask_notional,
    "m" => :maker_side,
    "R" => :reduce_only,
    "wt" => :stop_price_working_type,
    "ot" => :original_order_type,
    "ps" => :position_side,
    "cp" => :close_all,
    "AP" => :activation_price,
    "cr" => :callback_rate,
    "rp" => :realized_profit
  }

  embedded_schema do
    field :symbol, :string
    field :client_order_id, :string
    field :side, Ecto.Enum, values: @order_sides
    field :order_type, Ecto.Enum, values: @order_types
    field :time_in_force, Ecto.Enum, values: @time_in_forces
    field :original_quantity, :decimal
    field :original_price, :decimal
    field :avg_price, :decimal
    field :stop_price, :decimal
    field :execution_type, Ecto.Enum, values: @execution_types
    field :order_status, Ecto.Enum, values: @order_statuses
    field :order_id, :integer
    field :order_last_filled_qty, :decimal
    field :total_filled, :decimal
    field :last_fill_price, :decimal
    field :commission_asset, :string
    field :commission_amount, :decimal
    field :order_trade_time, :integer
    field :trade_id, :integer
    field :bid_notional, :decimal
    field :ask_notional, :decimal
    field :maker_side, :boolean
    field :reduce_only, :boolean
    field :stop_price_working_type, Ecto.Enum, values: @working_types
    field :original_order_type, Ecto.Enum, values: @order_types
    field :position_side, Ecto.Enum, values: @position_sides
    field :close_all, :boolean
    field :activation_price, :decimal
    field :callback_rate, :decimal
    field :realized_profit, :decimal
  end

  def changeset(event, attrs \\ %{}) do
    attrs =
      attrs
      |> map_keys(@fields)
      |> prepare_enums(~w(side order_type time_in_force execution_type order_status stop_price_working_type original_order_type position_side)a)

    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end
