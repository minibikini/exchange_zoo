defmodule ExchangeZoo.BitMEX.Model.Order do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :order_id, :string
    field :cl_ord_id, :string
    field :cl_ord_link_id, :string
    field :account, :integer
    field :symbol, :string
    field :side, :string
    field :order_qty, :integer
    field :price, :integer
    field :display_qty, :integer
    field :stop_px, :integer
    field :peg_offset_value, :integer
    field :peg_price_type, :string
    field :currency, :string
    field :settl_currency, :string
    field :ord_type, :string
    field :time_in_force, :string
    field :exec_inst, :string
    field :contingency_type, :string
    field :ord_status, :string
    field :triggered, :string
    field :working_indicator, :boolean
    field :ord_rej_reason, :string
    field :leaves_qty, :integer
    field :cum_qty, :integer
    field :avg_px, :integer
    field :text, :string
    field :transact_time, :utc_datetime_usec
    field :timestamp, :utc_datetime_usec
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
