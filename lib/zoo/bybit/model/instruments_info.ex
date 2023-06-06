defmodule ExchangeZoo.Bybit.Model.InstrumentsInfo do
  use ExchangeZoo.Model
  alias ExchangeZoo.Bybit.Model.InstrumentsInfo.Instrument

  @categories ~w(spot linear inverse option)a

  @primary_key false

  embedded_schema do
    field :category, Ecto.Enum, values: @categories
    field :next_page_cursor, :string

    embeds_many :list, Instrument
  end

  def changeset(instruments_info, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    instruments_info
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:list])
    |> cast_embed(:list)
  end
end

defmodule ExchangeZoo.Bybit.Model.InstrumentsInfo.Instrument do
  use ExchangeZoo.Model
  alias ExchangeZoo.Bybit.Model.InstrumentsInfo.Instrument.{
    LeverageFilter,
    PriceFilter,
    LotSizeFilter
  }

  @contract_types ~w(inverse_perpetual linear_perpetual linear_futures inverse_futures)a
  @option_types ~w(call put)a
  @statuses ~w(pre_launch trading settling delivering closed)a

  @primary_key false

  embedded_schema do
    field :symbol, :string

    field :status, Ecto.Enum, values: @statuses
    field :base_coin, :string
    field :quote_coin, :string
    field :launch_time, :integer
    field :delivery_time, :integer
    field :delivery_fee_rate, :decimal
    field :price_scale, :decimal
    field :unified_margin_trade, :boolean
    field :funding_interval, :integer
    field :settle_coin, :string

    # linear/inverse only
    field :contract_type, Ecto.Enum, values: @contract_types

    # option only
    field :options_type, Ecto.Enum, values: @option_types

    # spot only
    field :innovation, :integer

    embeds_one :leverage_filter, LeverageFilter
    embeds_one :price_filter, PriceFilter
    embeds_one :lot_size_filter, LotSizeFilter
  end

  def changeset(instrument, attrs \\ %{}) do
    attrs = prepare_enums(attrs, ~w(contract_type options_type status))

    instrument
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:leverage_filter, :price_filter, :lot_size_filter])
    |> cast_embed(:leverage_filter)
    |> cast_embed(:price_filter)
    |> cast_embed(:lot_size_filter)
  end
end

defmodule ExchangeZoo.Bybit.Model.InstrumentsInfo.Instrument.LeverageFilter do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :min_leverage, :decimal
    field :max_leverage, :decimal
    field :leverage_step, :decimal
  end

  def changeset(instrument, attrs \\ %{}) do
    cast(instrument, attrs, __MODULE__.__schema__(:fields))
  end
end

defmodule ExchangeZoo.Bybit.Model.InstrumentsInfo.Instrument.PriceFilter do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :min_price, :decimal
    field :max_price, :decimal
    field :tick_size, :decimal
  end

  def changeset(instrument, attrs \\ %{}) do
    cast(instrument, attrs, __MODULE__.__schema__(:fields))
  end
end

defmodule ExchangeZoo.Bybit.Model.InstrumentsInfo.Instrument.LotSizeFilter do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :min_order_qty, :decimal
    field :max_order_qty, :decimal
    field :qty_step, :decimal
    field :post_only_max_order_qty, :decimal
  end

  def changeset(instrument, attrs \\ %{}) do
    cast(instrument, attrs, __MODULE__.__schema__(:fields))
  end
end
