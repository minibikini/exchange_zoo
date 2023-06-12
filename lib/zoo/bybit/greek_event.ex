defmodule ExchangeZoo.Bybit.Model.GreekEvent do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :base_coin, :string
    field :total_delta, :decimal
    field :total_gamma, :decimal
    field :total_vega, :decimal
    field :total_theta, :decimal
  end

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
