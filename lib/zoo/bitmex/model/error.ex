defmodule ExchangeZoo.BitMEX.Model.Error do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :message, :string
    field :name, :string
  end

  def changeset(error, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(error, attrs, __MODULE__.__schema__(:fields))
  end
end
