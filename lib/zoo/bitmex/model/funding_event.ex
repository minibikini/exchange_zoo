defmodule ExchangeZoo.BitMEX.Model.FundingEvent do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :symbol, :string
    field :funding_rate, :decimal
    field :funding_rate_daily, :decimal
    field :funding_interval, :utc_datetime_usec
    field :timestamp, :utc_datetime_usec
  end

  def changeset(event, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end
