defmodule ExchangeZoo.Binance.Model.MarkPriceUpdateEvent do
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "E" => :event_time,
    "s" => :symbol,
    "p" => :mark_price,
    "i" => :index_price,
    "P" => :estimated_settle_price,
    "r" => :funding_rate,
    "T" => :next_funding_time
  }

  embedded_schema do
    field :event_time, :integer
    field :symbol, :string
    field :mark_price, :decimal
    field :index_price, :decimal
    field :estimated_settle_price, :decimal
    field :funding_rate, :decimal
    field :next_funding_time, :integer
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)
    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end
