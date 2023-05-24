defmodule ExchangeZoo.BinanceUS.Model.BookTickerEvent do
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "u" => :order_book_update_id,
    "s" => :symbol,
    "b" => :best_bid_price,
    "B" => :best_bid_qty,
    "a" => :best_ask_price,
    "A" => :best_ask_qty
  }

  embedded_schema do
    field :order_book_update_id, :integer
    field :symbol, :string
    field :best_bid_price, :decimal
    field :best_bid_qty, :decimal
    field :best_ask_price, :decimal
    field :best_ask_qty, :decimal
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)
    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end

