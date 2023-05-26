defmodule ExchangeZoo.Binance.Model.AssetIndexUpdateEvent do
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "E" => :event_time,
    "s" => :symbol,
    "i" => :index,
    "b" => :bid_buffer,
    "a" => :ask_buffer,
    "B" => :bid_rate,
    "A" => :ask_rate,
    "q" => :auto_exchange_bid_buffer,
    "g" => :auto_exchange_ask_buffer,
    "Q" => :auto_exchange_bid_rate,
    "G" => :auto_exchange_ask_rate
  }

  embedded_schema do
    field :event_time, :integer
    field :symbol, :string
    field :index, :decimal
    field :bid_buffer, :decimal
    field :ask_buffer, :decimal
    field :bid_rate, :decimal
    field :ask_rate, :decimal
    field :auto_exchange_bid_buffer, :decimal
    field :auto_exchange_ask_buffer, :decimal
    field :auto_exchange_bid_rate, :decimal
    field :auto_exchange_ask_rate, :decimal
  end

  def changeset(asset_index, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)
    cast(asset_index, attrs, __MODULE__.__schema__(:fields))
  end
end

