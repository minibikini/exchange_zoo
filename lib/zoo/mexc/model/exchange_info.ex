defmodule ExchangeZoo.MEXC.Model.ExchangeInfo do
  use ExchangeZoo.Model
  alias ExchangeZoo.MEXC.Model.ExchangeInfo.Symbol

  @primary_key false

  embedded_schema do
    field :timezone, :string
    field :server_time, :integer
    field :rate_limits, {:array, :string} # TODO
    field :exchange_filters, {:array, :string} # TODO

    embeds_many :symbols, Symbol
  end

  def changeset(exchange_info, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    exchange_info
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:symbols])
    |> cast_embed(:symbols)
  end
end

defmodule ExchangeZoo.MEXC.Model.ExchangeInfo.Symbol do
  use ExchangeZoo.Model

  @primary_key false

  @statuses ~w(enabled disabled)a
  @order_types ~w(limit market limit_maker immediate_or_cancel fill_or_kill)a

  embedded_schema do
    field :symbol, :string
    field :full_name, :string
    field :status, Ecto.Enum, values: @statuses
    field :base_asset, :string
    field :base_asset_precision, :integer
    field :quote_asset, :string
    field :quote_precision, :integer
    field :quote_asset_precision, :integer
    field :base_commission_precision, :integer
    field :quote_commission_precision, :integer
    field :order_types, {:array, Ecto.Enum}, values: @order_types
    field :quote_order_qty_market_allowed, :boolean
    field :is_spot_trading_allowed, :boolean
    field :is_margin_trading_allowed, :boolean
    field :permissions, {:array, :string} # TODO
    field :filters, {:array, :string} # TODO
    field :max_quote_amount, :decimal
    field :maker_commission, :decimal
    field :taker_commission, :decimal
    field :quote_amount_precision, :decimal
    field :base_size_precision, :decimal
    field :quote_amount_precision_market, :decimal
    field :max_quote_amount_market, :decimal
  end

  def changeset(symbol, attrs \\ %{}) do
    attrs = prepare_enums(attrs, ["status", "order_types"])
    cast(symbol, attrs, __MODULE__.__schema__(:fields))
  end
end
