defmodule ExchangeZoo.Binance.Model.ListenKeyExpiredEvent do
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "E" => :event_time
  }

  embedded_schema do
    field :event_time, :integer
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)
    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end
