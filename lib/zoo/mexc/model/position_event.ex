defmodule ExchangeZoo.MEXC.Model.PositionEvent do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :position_id, :integer
    field :symbol, :string
    field :hold_vol, :decimal
    field :position_type, Ecto.Enum, values: [long: 1, short: 2]
    field :open_type, Ecto.Enum, values: [isolated: 1, cross: 2]
    field :state, Ecto.Enum, values: [holding: 1, system_holding: 2, closed: 3]
    field :frozen_vol, :decimal
    field :close_vol, :decimal
    field :hold_avg_price, :decimal
    field :close_avg_price, :decimal
    field :open_avg_price, :decimal
    field :liquidate_price, :decimal
    field :oim, :decimal
    field :adl_level, :integer
    field :im, :decimal
    field :hold_fee, :decimal
    field :realised, :decimal
    field :leverage, :integer
    field :auto_add_im, :boolean
    field :create_time, :integer
    field :update_time, :integer
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
