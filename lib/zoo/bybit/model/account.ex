defmodule ExchangeZoo.Bybit.Model.Account do
  use ExchangeZoo.Model

  @primary_key false

  @unified_margin_statuses [regular: 1, unified_margin: 2, unified_trade: 3, uta_pro: 4]

  embedded_schema do
    field :dcp_status, :string
    field :margin_mode, :string
    field :unified_margin_status, Ecto.Enum, values: @unified_margin_statuses
    field :smp_group, :integer
    field :time_window, :integer
    field :updated_time, :integer
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
