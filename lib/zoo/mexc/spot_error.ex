defmodule ExchangeZoo.MEXC.Model.SpotError do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :code, :integer
    field :msg, :string
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
