defmodule ExchangeZoo.BitMEX.Model.ExecutionEvent do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :exec_id, :string
    field :order_id, :string
    field :cl_ord_id, :string
    field :cl_ord_link_id, :string
    field :account, :integer
    field :symbol, :string
    field :side, :string
    field :last_qty, :integer
    field :last_px, :decimal
    field :underlying_last_px, :decimal
    field :last_mkt, :string
    field :last_liquidity_ind, :string
    field :simple_order_qty, :integer
    field :order_qty, :integer
    field :price, :decimal
    field :display_qty, :integer
    field :stop_px, :decimal
    field :peg_offset_value, :integer
    field :peg_price_type, :string
    field :currency, :string
    field :settl_currency, :string
    field :exec_type, :string
    field :ord_type, :string
    field :time_in_force, :string
    field :exec_inst, :string
    field :contingency_type, :string
    field :ex_destination, :string
    field :ord_status, :string
    field :triggered, :string
    field :working_indicator, :boolean
    field :ord_rej_reason, :string
    field :simple_leaves_qty, :integer
    field :leaves_qty, :integer
    field :simple_cum_qty, :decimal
    field :cum_qty, :integer
    field :avg_px, :decimal
    field :commission, :decimal
    field :trade_publish_indicator, :string
    field :multi_leg_reporting_type, :string
    field :text, :string
    field :trd_match_id, :string
    field :exec_cost, :integer
    field :exec_comm, :integer
    field :home_notional, :decimal
    field :foreign_notional, :integer
    field :transact_time, :utc_datetime_usec
    field :timestamp, :utc_datetime_usec
  end

  def changeset(record, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(record, attrs, __MODULE__.__schema__(:fields))
  end
end
