defmodule ExchangeZoo.Binance.Model.AccountConfigUpdateEvent do
  use ExchangeZoo.Model
  alias ExchangeZoo.Binance.Model.AccountConfigUpdateEvent.{TradePair, MarginMode}

  @primary_key false

  @fields %{
    "E" => :event_time,
    "T" => :transaction_time,
    "ac" => :trade_pair,
    "ai" => :margin_mode
  }

  embedded_schema do
    field :event_time, :integer
    field :transaction_time, :integer

    embeds_one :trade_pair, TradePair
    embeds_one :margin_mode, MarginMode
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)

    event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:trade_pair, :margin_mode])
    |> cast_embed(:trade_pair)
    |> cast_embed(:margin_mode)
  end
end

defmodule ExchangeZoo.Binance.Model.AccountConfigUpdateEvent.TradePair do
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "s" => :symbol,
    "l" => :leverage
  }

  embedded_schema do
    field :symbol, :string
    field :leverage, :integer
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)
    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end

defmodule ExchangeZoo.Binance.Model.AccountConfigUpdateEvent.MarginMode do
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "j" => :multi_assets_mode
  }

  embedded_schema do
    field :multi_assets_mode, :boolean
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)
    cast(event, attrs, __MODULE__.__schema__(:fields))
  end
end
