defmodule ExchangeZoo.MEXC.Model.ContractDetail do
  use ExchangeZoo.Model

  @primary_key false

  @risk_limit_types ~w(by_volume by_value)a

  embedded_schema do
    field :symbol, :string
    field :display_name, :string
    field :display_name_en, :string
    field :position_open_type, Ecto.Enum, values: [isolated: 1, cross: 2, both: 3]
    field :base_coin, :string
    field :quote_coin, :string
    field :settle_coin, :string
    field :contract_size, :decimal
    field :min_leverage, :integer
    field :max_leverage, :integer
    field :price_scale, :integer
    field :vol_scale, :integer
    field :amount_scale, :integer
    field :price_unit, :decimal
    field :vol_unit, :integer
    field :min_vol, :decimal
    field :max_vol, :decimal
    field :bid_limit_price_rate, :decimal
    field :ask_limit_price_rate, :decimal
    field :taker_fee_rate, :decimal
    field :maker_fee_rate, :decimal
    field :maintenance_margin_rate, :decimal
    field :initial_margin_rate, :decimal
    field :risk_base_vol, :decimal
    field :risk_incr_vol, :decimal
    field :risk_incr_mmr, :decimal
    field :risk_incr_imr, :decimal
    field :risk_level_limit, :integer
    field :price_coefficient_variation, :decimal
    field :index_origin, {:array, :string}
    field :state, Ecto.Enum, values: [enabled: 0, delivery: 1, completed: 2, offline: 3, pause: 4]
    field :is_new, :boolean
    field :is_hot, :boolean
    field :is_hidden, :boolean
    field :api_allowed, :boolean
    field :concept_plate, {:array, :string}
    field :risk_limit_type, Ecto.Enum, values: @risk_limit_types
    field :max_num_orders, {:array, :integer}
    field :market_order_max_level, :integer
    field :market_order_price_limit_rate1, :decimal
    field :market_order_price_limit_rate2, :decimal
    field :trigger_protect, :decimal
    field :appraisal, :integer
    field :show_appraisal_countdown, :integer
    field :automatic_delivery, :integer
  end

  def changeset(contract_detail, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    cast(contract_detail, attrs, __MODULE__.__schema__(:fields))
  end
end
