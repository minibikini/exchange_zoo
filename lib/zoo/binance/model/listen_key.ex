defmodule ExchangeZoo.Binance.Model.ListenKey do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :listen_key, :string
  end

  def changeset(listen_key, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(listen_key, attrs, __MODULE__.__schema__(:fields))
  end
end
