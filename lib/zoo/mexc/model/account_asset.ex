defmodule ExchangeZoo.MEXC.Model.AccountAsset do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :currency, :string
    field :position_margin, :decimal
    field :frozen_balance, :decimal
    field :available_balance, :decimal
    field :cash_balance, :decimal
    field :equity, :decimal
    field :unrealized, :decimal
    field :bonus, :decimal
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
