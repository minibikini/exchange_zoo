defmodule ExchangeZoo.MEXC.Model.Order do
  use ExchangeZoo.Model

  @primary_key false

  @sides [open_long: 1, close_short: 2, open_short: 3, close_long: 4]
  @categories [limit_order: 1, system_take_over_delegate: 2, close_delegate: 3, adl_reduction: 4]
  @order_types [limit_order: 1, post_only_maker: 2, immediate_or_cancel: 3, fill_or_kill: 4, market_order: 5, convert_market_price_to_current_price: 6]
  @open_types [isolated: 1, cross: 2]
  @states [uninformed: 1, uncompleted: 2, completed: 3, cancelled: 4, invalid: 5]
  @error_codes [normal: 0, parameter_errors: 1, account_balance_is_insufficient: 2, position_does_not_exist: 3, position_insufficient: 4, price_exceeded_close_price: 5, close_price_exceeded_fair_price: 6, exceeded_risk_quota_restrictions: 7, system_canceled: 8]

  embedded_schema do
    field :order_id, :string
    field :symbol, :string
    field :position_id, :integer
    field :price, :decimal
    field :vol, :decimal
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
    field :stop_loss_price, :decimal
    field :take_profit_price, :decimal
  end

  def changeset(order, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
