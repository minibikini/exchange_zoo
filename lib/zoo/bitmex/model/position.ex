defmodule ExchangeZoo.BitMEX.Model.Position do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :account, :integer
    field :symbol, :string
    field :currency, :string
    field :underlying, :string
    field :quote_currency, :string
    field :commission, :integer
    field :init_margin_req, :integer
    field :maint_margin_req, :integer
    field :risk_limit, :integer
    field :leverage, :integer
    field :cross_margin, :boolean
    field :deleverage_percentile, :integer
    field :rebalanced_pnl, :integer
    field :prev_realised_pnl, :integer
    field :prev_unrealised_pnl, :integer
    field :opening_qty, :integer
    field :open_order_buy_qty, :integer
    field :open_order_buy_cost, :integer
    field :open_order_buy_premium, :integer
    field :open_order_sell_qty, :integer
    field :open_order_sell_cost, :integer
    field :open_order_sell_premium, :integer
    field :current_qty, :integer
    field :current_cost, :integer
    field :current_comm, :integer
    field :realised_cost, :integer
    field :unrealised_cost, :integer
    field :gross_open_premium, :integer
    field :is_open, :boolean
    field :mark_price, :integer
    field :mark_value, :integer
    field :risk_value, :integer
    field :home_notional, :integer
    field :foreign_notional, :integer
    field :pos_state, :string
    field :pos_cost, :integer
    field :pos_cross, :integer
    field :pos_comm, :integer
    field :pos_loss, :integer
    field :pos_margin, :integer
    field :pos_maint, :integer
    field :init_margin, :integer
    field :maint_margin, :integer
    field :realised_pnl, :integer
    field :unrealised_pnl, :integer
    field :unrealised_pnl_pcnt, :integer
    field :unrealised_roe_pcnt, :integer
    field :avg_cost_price, :integer
    field :avg_entry_price, :integer
    field :break_even_price, :integer
    field :margin_call_price, :integer
    field :liquidation_price, :integer
    field :bankrupt_price, :integer
    field :timestamp, :utc_datetime_usec
  end

  def changeset(position, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(position, attrs, __MODULE__.__schema__(:fields))
  end
end
