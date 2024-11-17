defmodule ExchangeZoo.Bybit.Model.PositionEvent do
  use ExchangeZoo.Model

  @primary_key false

  @categories ~w(spot linear inverse option)a
  @sides ~w(buy sell)a
  @tpsl_modes ~w(unknown full partial)a
  @position_statuses ~w(normal liq adl)a

  embedded_schema do
    field :category, Ecto.Enum, values: @categories
    field :symbol, :string
    field :side, Ecto.Enum, values: @sides
    field :size, :decimal
    field :position_idx, Ecto.Enum, values: [both: 0, buy: 1, sell: 2]
    field :trade_mode, Ecto.Enum, values: [cross: 0, isolated: 1]
    field :position_value, :decimal
    field :risk_id, :integer
    field :risk_limit_value, :decimal
    field :entry_price, :decimal
    field :mark_price, :decimal
    field :leverage, :decimal
    field :position_balance, :decimal
    field :auto_add_margin, :integer
    field :position_mm, :decimal
    field :position_im, :decimal
    field :liq_price, :decimal
    field :bust_price, :decimal
    field :tpsl_mode, Ecto.Enum, values: @tpsl_modes
    field :take_profit, :decimal
    field :stop_loss, :decimal
    field :trailing_stop, :decimal
    field :unrealised_pnl, :decimal
    field :cum_realised_pnl, :decimal
    field :position_status, Ecto.Enum, values: @position_statuses
    field :adl_rank_indicator, :integer
    field :created_time, :integer
    field :updated_time, :integer
  end

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
