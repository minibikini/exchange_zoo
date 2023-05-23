defmodule ExchangeZoo.Binance.Model.BookTicker do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :symbol, :string
    field :bid_price, :decimal
    field :bid_qty, :decimal
    field :ask_price, :decimal
    field :ask_qty, :decimal
    field :time, :integer
  end

  def changeset(book_ticker, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(book_ticker, attrs, __MODULE__.__schema__(:fields))
  end
end
