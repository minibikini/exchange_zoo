defmodule ExchangeZoo.BitMEX.Model.Event do
  use ExchangeZoo.Model

  @primary_key false

  @actions ~w(partial update insert delete)a

  embedded_schema do
    field :table, :string
    field :action, Ecto.Enum, values: @actions
    field :keys, {:array, :string}
    field :types, {:map, :string}
    field :filter, {:map, :string}

    # embeds_many :data, Data
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
