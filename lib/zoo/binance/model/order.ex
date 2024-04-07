defmodule ExchangeZoo.Binance.Model.Order do
  use ExchangeZoo.Model

  @primary_key false

  @order_types ~w(limit market stop stop_market take_profit take_profit_market trailing_stop_market)a
  @order_sides ~w(buy sell)a
  @order_statuses ~w(new partially_filled filled canceled rejected expired)a
  @position_sides ~w(both long short)a
  @time_in_forces ~w(gtc ioc fok gtx gtd gte_gtc)a
  @working_types ~w(mark_price contract_price)a

  embedded_schema do
    field :activate_price, :decimal
    field :avg_price, :decimal
    field :client_order_id, :string
    field :close_position, :boolean
    field :cum_quote, :decimal
    field :executed_qty, :decimal
    field :order_id, :integer
    field :orig_qty, :decimal
    field :orig_type, Ecto.Enum, values: @order_types
    field :position_side, Ecto.Enum, values: @position_sides
    field :price, :decimal
    field :price_protect, :boolean
    field :price_rate, :decimal
    field :reduce_only, :boolean
    field :side, Ecto.Enum, values: @order_sides
    field :status, Ecto.Enum, values: @order_statuses
    field :stop_price, :decimal
    field :symbol, :string
    field :time, :integer
    field :time_in_force, Ecto.Enum, values: @time_in_forces
    field :type, Ecto.Enum, values: @order_types
    field :update_time, :integer
    field :working_type, Ecto.Enum, values: @working_types
  end

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(~w(orig_type position_side side status time_in_force type working_type))

    order
    |> cast(attrs, __MODULE__.__schema__(:fields))
  end
end
