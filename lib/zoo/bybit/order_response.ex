defmodule ExchangeZoo.Bybit.Model.OrderResponse do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :order_id, :string
    field :order_link_id, :string
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
