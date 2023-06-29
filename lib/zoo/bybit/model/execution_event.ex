defmodule ExchangeZoo.Bybit.Model.ExecutionEvent do
  use ExchangeZoo.Model

  @primary_key false

  @categories ~w(spot linear inverse option)a
  @sides ~w(buy sell)a
  @order_types ~w(market limit)a
  @stop_order_types ~w(unknown take_profit stop_loss trailing_stop stop partial_take_profit partial_stop_loss tpsl_order)a
  @exec_types ~w(trade adl_trade funding bust_trade delivery block_trade)a

  embedded_schema do
    field :category, Ecto.Enum, values: @categories
    field :symbol, :string
    field :is_leverage, :boolean
    field :order_id, :string
    field :order_link_id, :string
    field :side, Ecto.Enum, values: @sides
    field :order_price, :decimal
    field :order_qty, :decimal
    field :leaves_qty, :decimal
    field :order_type, Ecto.Enum, values: @order_types
    field :stop_order_type, Ecto.Enum, values: @stop_order_types
    field :exec_fee, :decimal
    field :exec_id, :string
    field :exec_price, :decimal
    field :exec_qty, :decimal
    field :exec_type, Ecto.Enum, values: @exec_types
    field :exec_value, :decimal
    field :exec_time, :integer
    field :is_maker, :boolean
    field :fee_rate, :decimal
    field :trade_iv, :decimal
    field :mark_iv, :decimal
    field :mark_price, :decimal
    field :index_price, :decimal
    field :underlying_price, :decimal
    field :block_trade_id, :string
    field :closed_size, :decimal
  end

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
