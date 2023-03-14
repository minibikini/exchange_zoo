defmodule ExchangeZoo.Binance.Model.ListenKey do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :listen_key, :string
  end

  def changeset(order, attrs \\ %{}) do
    attrs = update_values(attrs, ~w(listen_key), &String.downcase/1)

    order
    |> cast(attrs, __MODULE__.__schema__(:fields))
  end
end
