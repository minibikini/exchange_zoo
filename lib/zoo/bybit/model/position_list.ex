defmodule ExchangeZoo.Bybit.Model.PositionList do
  use ExchangeZoo.Model
  alias ExchangeZoo.Bybit.Model.PositionList.Position

  @primary_key false

  @categories ~w(spot linear inverse option)a

  embedded_schema do
    field :category, Ecto.Enum, values: @categories
    field :next_page_cursor, :string

    embeds_many :list, Position
  end

  def changeset(position_list, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    position_list
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:list])
    |> cast_embed(:list)
  end
end

defmodule ExchangeZoo.Bybit.Model.PositionList.Position do
  use ExchangeZoo.Model

  @primary_key false

  @sides ~w(buy sell)a
  @position_statuses ~w(normal liq adl)a
  @tpsl_modes ~w(full)a

  embedded_schema do
    field :position_idx, Ecto.Enum, values: [both: 0, buy: 1, sell: 2]
    field :risk_id, :integer
    field :risk_limit_value, :decimal
    field :symbol, :string
    field :side, Ecto.Enum, values: @sides
    field :size, :decimal
    field :avg_price, :decimal
    field :position_value, :decimal
    field :trade_mode, Ecto.Enum, values: [cross: 0, isolated: 1]
    field :auto_add_margin, :integer
    field :position_status, Ecto.Enum, values: @position_statuses
    field :leverage, :decimal
    field :mark_price, :decimal
    field :liq_price, :decimal
    field :bust_price, :decimal
    field :position_im, :decimal
    field :position_mm, :decimal
    field :position_balance, :decimal
    field :tpsl_mode, Ecto.Enum, values: @tpsl_modes
    field :take_profit, :decimal
    field :stop_loss, :decimal
    field :trailing_stop, :decimal
    field :unrealised_pnl, :decimal
    field :cum_realised_pnl, :decimal
    field :adl_rank_indicator, :integer
    field :created_time, :integer
    field :updated_time, :integer
  end

  def changeset(position, attrs \\ %{}) do
    attrs = prepare_enums(attrs, enum_fields() |> Enum.map(&to_string/1))
    cast(position, attrs, __MODULE__.__schema__(:fields))
  end
end
