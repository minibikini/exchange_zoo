defmodule ExchangeZoo.<%= @exchange.name %>.Model.<%= @model.name %> do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    <%= Mix.Zoo.Model.format_fields_for_schema(@model) %>
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
