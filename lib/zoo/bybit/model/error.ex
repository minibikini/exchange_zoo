defmodule ExchangeZoo.Bybit.Model.Error do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :ret_code, :integer
    field :ret_msg, :string
    field :ret_ext_info, :map
    field :time, :integer
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
