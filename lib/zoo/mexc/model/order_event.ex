defmodule ExchangeZoo.MEXC.Model.OrderEvent do
  use ExchangeZoo.Model

  @primary_key false

  @sides [open_long: 1, close_short: 2, open_short: 3, close_long: 4]
  @categories [limit_order: 1, system_take_over_delegate: 2, close_delegate: 3, adl_reduction: 4]
  @order_types [limit_order: 1, post_only_maker: 2, immediate_or_cancel: 3, fill_or_kill: 4, market_order: 5, convert_market_price_to_current_price: 6]
  @open_types [isolated: 1, cross: 2]
  @states [uninformed: 1, uncompleted: 2, completed: 3, cancelled: 4, invalid: 5]
  @error_codes [normal: 0, param_invalid: 1, insufficient_balance: 2, position_not_exists: 3, position_not_enough: 4, position_liq: 5, order_liq: 6, risk_level_limit: 7, sys_cancel: 8, position_mode_not_match: 9, reduce_only_liq: 10, contract_not_enable: 11, delivery_cancel: 12, position_liq_cancel: 13, adl_cancel: 14, black_user_cancel: 15, settle_funding_cancel: 16, position_im_change_cancel: 17, ioc_cancel: 18, fok_cancel: 19, post_only_cancel: 20, market_cancel: 21]

  embedded_schema do
    field :order_id, :string
    field :symbol, :string
    field :position_id, :integer
    field :price, :decimal
    field :vol, :decimal
    field :remain_vol, :decimal
    field :leverage, :integer
    field :side, Ecto.Enum, values: @sides
    field :category, Ecto.Enum, values: @categories
    field :order_type, Ecto.Enum, values: @order_types
    field :deal_avg_price, :decimal
    field :deal_vol, :decimal
    field :order_margin, :decimal
    field :used_margin, :decimal
    field :taker_fee, :decimal
    field :maker_fee, :decimal
    field :profit, :decimal
    field :fee_currency, :string
    field :open_type, Ecto.Enum, values: @open_types
    field :state, Ecto.Enum, values: @states
    field :error_code, Ecto.Enum, values: @error_codes
    field :external_oid, :string
    field :create_time, :integer
    field :update_time, :integer
    field :version, :integer
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
