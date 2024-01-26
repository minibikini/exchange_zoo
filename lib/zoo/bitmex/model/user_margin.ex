defmodule ExchangeZoo.BitMEX.Model.UserMargin do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :account, :integer
    field :currency, :string
    field :risk_limit, :integer
    field :state, :string
    field :amount, :integer
    field :prev_realised_pnl, :integer
    field :gross_comm, :integer
    field :gross_open_cost, :integer
    field :gross_open_premium, :integer
    field :gross_exec_cost, :integer
    field :gross_mark_value, :integer
    field :risk_value, :integer
    field :init_margin, :integer
    field :maint_margin, :integer
    field :target_excess_margin, :integer
    field :realised_pnl, :integer
    field :unrealised_pnl, :integer
    field :wallet_balance, :integer
    field :margin_balance, :integer
    field :margin_leverage, :integer
    field :margin_used_pcnt, :integer
    field :excess_margin, :integer
    field :available_margin, :integer
    field :withdrawable_margin, :integer
    field :maker_fee_discount, :integer
    field :taker_fee_discount, :integer
    field :timestamp, :utc_datetime_usec
  end

  def changeset(user_margin, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(user_margin, attrs, __MODULE__.__schema__(:fields))
  end
end
