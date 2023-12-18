defmodule ExchangeZoo.MEXC.Model.Leverage do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :position_type, Ecto.Enum, values: [long: 1, short: 2]
    field :level, :integer
    field :leverage, :integer
    field :imr, :decimal # The leverage risk limit level corresponds to initial margin rate
    field :mmr, :decimal # Leverage risk limit level corresponds to maintenance margin rate
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
