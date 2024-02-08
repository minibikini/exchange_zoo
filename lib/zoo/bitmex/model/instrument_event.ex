defmodule ExchangeZoo.BitMEX.Model.InstrumentEvent do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :symbol, :string
    field :open_value, :integer
    field :fair_price, :decimal
    field :mark_price, :decimal
    field :timestamp, :utc_datetime_usec
  end

  def changeset(event, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end
