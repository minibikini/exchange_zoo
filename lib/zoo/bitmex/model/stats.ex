defmodule ExchangeZoo.BitMEX.Model.Stats do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :root_symbol, :string
    field :currency, :string
    field :volume24h, :integer
    field :turnover24h, :integer
    field :open_interest, :integer
    field :open_value, :integer
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
