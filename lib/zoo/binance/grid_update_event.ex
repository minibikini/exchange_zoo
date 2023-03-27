defmodule ExchangeZoo.Binance.Model.GridUpdateEvent do
  use ExchangeZoo.Model
  alias ExchangeZoo.Binance.Model.GridUpdateEvent.GridUpdate

  @primary_key false

  @fields %{
    "E" => :event_time,
    "T" => :transaction_time,
    "gu" => :grid_update
  }

  embedded_schema do
    field :event_time, :integer
    field :transaction_time, :integer

    embeds_one :grid_update, GridUpdate
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)

    event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:grid_update])
    |> cast_embed(:grid_update)
  end
end

defmodule ExchangeZoo.Binance.Model.GridUpdateEvent.GridUpdate do
  use ExchangeZoo.Model

  @primary_key false

  @strategy_types ~w(grid)a
  @strategy_statuses ~w(new working cancelled expired)a

  @fields %{
    "si" => :strategy_id,
    "st" => :strategy_type,
    "ss" => :strategy_status,
    "s" => :symbol,
    "r" => :realized_pnl,
    "up" => :unmatched_avg_price,
    "uq" => :unmatched_qty,
    "uf" => :unmatched_fee,
    "mp" => :matched_pnl,
    "ut" => :update_time
  }

  embedded_schema do
    field :strategy_id, :integer
    field :strategy_type, Ecto.Enum, values: @strategy_types
    field :strategy_status, Ecto.Enum, values: @strategy_statuses
    field :symbol, :string
    field :realized_pnl, :decimal
    field :unmatched_avg_price, :decimal
    field :unmatched_qty, :decimal
    field :unmatched_fee, :decimal
    field :matched_pnl, :decimal
    field :update_time, :integer
  end

  def changeset(event, attrs \\ %{}) do
    attrs =
      attrs
      |> map_keys(@fields)
      |> prepare_enums(~w(strategy_type strategy_status)a)

    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end

