defmodule ExchangeZoo.Binance.Model.AssetIndex do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :symbol, :string
    field :time, :integer
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
    attrs = underscore_keys(attrs)
    cast(asset_index, attrs, __MODULE__.__schema__(:fields))
  end
end
