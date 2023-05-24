defmodule ExchangeZoo.Binance.Model.AccountUpdateEvent do
  use ExchangeZoo.Model
  alias ExchangeZoo.Binance.Model.AccountUpdateEvent.AccountUpdate

  @primary_key false

  @fields %{
    "E" => :event_time,
    "T" => :transaction_time,
    "a" => :account_update
  }

  embedded_schema do
    field :event_time, :integer
    field :transaction_time, :integer

    embeds_one :account_update, AccountUpdate
  end

  def changeset(event, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)

    event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:account_update])
    |> cast_embed(:account_update)
  end
end

defmodule ExchangeZoo.Binance.Model.AccountUpdateEvent.AccountUpdate do
  use ExchangeZoo.Model
  alias ExchangeZoo.Binance.Model.AccountUpdateEvent.{Balance, Position}

  @primary_key false

  @reason_types ~w(deposit withdraw order funding_fee withdraw_reject adjustment insurance_clear admin_deposit admin_withdraw margin_transfer margin_type_change asset_transfer options_premium_fee options_settle_profit auto_exchange coin_swap_deposit coin_swap_withdraw)a

  @fields %{
    "m" => :reason_type,
    "B" => :balances,
    "P" => :positions
  }

  embedded_schema do
    field :reason_type, Ecto.Enum, values: @reason_types

    embeds_many :balances, Balance
    embeds_many :positions, Position
  end

  def changeset(event, attrs \\ %{}) do
    attrs =
      attrs
      |> map_keys(@fields)
      |> prepare_enums(~w(reason_type)a)

    event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:balances, :positions])
    |> cast_embed(:balances)
    |> cast_embed(:positions)
  end
end

defmodule ExchangeZoo.Binance.Model.AccountUpdateEvent.Balance do
  use ExchangeZoo.Model

  @primary_key false

  @fields %{
    "a" => :asset,
    "wb" => :wallet_balance,
    "cw" => :cross_wallet_balance,
    "bc" => :balance_change
  }

  embedded_schema do
    field :asset, :string
    field :wallet_balance, :decimal
    field :cross_wallet_balance, :decimal
    field :balance_change, :decimal
  end

  def changeset(balance, attrs \\ %{}) do
    attrs = map_keys(attrs, @fields)
    cast(balance, attrs, __MODULE__.__schema__(:fields))
  end
end

defmodule ExchangeZoo.Binance.Model.AccountUpdateEvent.Position do
  use ExchangeZoo.Model

  @primary_key false

  @sides ~w(both long short)a
  @margin_types ~w(isolated cross)a

  @fields %{
    "s" => :symbol,
    "ps" => :side,
    "pa" => :amount,
    "ep" => :entry_price,
    "cr" => :accumulated_realized,
    "up" => :unrealized_pnl,
    "mt" => :margin_type,
    "iw" => :isolated_wallet
  }

  embedded_schema do
    field :symbol, :string
    field :side, Ecto.Enum, values: @sides
    field :amount, :decimal
    field :entry_price, :decimal
    field :accumulated_realized, :decimal
    field :unrealized_pnl, :decimal
    field :margin_type, Ecto.Enum, values: @margin_types
    field :isolated_wallet, :decimal
  end

  def changeset(position, attrs \\ %{}) do
    attrs =
      attrs
      |> map_keys(@fields)
      |> prepare_enums(~w(side margin_type)a)

    cast(position, attrs, __MODULE__.__schema__(:fields))
  end
end

