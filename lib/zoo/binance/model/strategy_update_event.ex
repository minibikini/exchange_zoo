defmodule ExchangeZoo.Binance.Model.StrategyUpdateEvent do
  use ExchangeZoo.Model
  alias ExchangeZoo.Binance.Model.StrategyUpdateEvent.StrategyUpdate

  @primary_key false

  @fields %{
    "E" => :event_time,
    "T" => :transaction_time,
    "su" => :strategy_update
  }

  embedded_schema do
    field :event_time, :integer
    field :transaction_time, :integer

    embeds_one :strategy_update, StrategyUpdate
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)

    event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:strategy_update])
    |> cast_embed(:strategy_update)
  end
end

defmodule ExchangeZoo.Binance.Model.StrategyUpdateEvent.StrategyUpdate do
  use ExchangeZoo.Model

  @primary_key false

  @strategy_types ~w(grid)a
  @strategy_statuses ~w(new working cancelled expired)a

  @fields %{
    "si" => :strategy_id,
    "st" => :strategy_type,
    "ss" => :strategy_status,
    "s" => :symbol,
    "ut" => :update_time,
    "c" => :opcode
  }

  embedded_schema do
    field :strategy_id, :integer
    field :strategy_type, Ecto.Enum, values: @strategy_types
    field :strategy_status, Ecto.Enum, values: @strategy_statuses
    field :symbol, :string
    field :update_time, :integer
    field :opcode, :integer
  end

  def changeset(event, attrs \\ %{}) do
    attrs =
      attrs
      |> map_keys(@fields)
      |> prepare_enums(~w(strategy_type strategy_status)a)

    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end
