defmodule ExchangeZoo.Binance.Model.MarginCallEvent do
  alias ExchangeZoo.Binance.Model.MarginCallEvent.Position
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "E" => :event_time,
    "cw" => :cross_wallet_balance,
    "p" => :positions
  }

  embedded_schema do
    field :event_time, :integer
    field :cross_wallet_balance, :decimal

    embeds_many :positions, Position
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)

    event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:positions])
    |> cast_embed(:positions)
  end
end

defmodule ExchangeZoo.Binance.Model.MarginCallEvent.Position do
  use ExchangeZoo.Model

  @primary_key false

  @sides ~w(both long short)a
  @margin_types ~w(isolated crossed)a

  @fields %{
    "s" => :symbol,
    "ps" => :side,
    "pa" => :amount,
    "mt" => :margin_type,
    "iw" => :isolated_wallet,
    "mp" => :mark_price,
    "up" => :unrealized_pnl,
    "mm" => :maint_margin_req
  }

  embedded_schema do
    field :symbol, :string
    field :side, Ecto.Enum, values: @sides
    field :amount, :decimal
    field :margin_type, Ecto.Enum, values: @margin_types
    field :isolated_wallet, :decimal
    field :mark_price, :decimal
    field :unrealized_pnl, :decimal
    field :maint_margin_req, :decimal
  end

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> map_keys(@fields)
      |> prepare_enums(~w(side margin_type)a)

    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
