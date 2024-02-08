defmodule ExchangeZoo.BitMEX.Model.MarginEvent do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :account, :integer
    field :currency, :string
    field :risk_limit, :integer
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
    field :margin_leverage, :decimal
    field :margin_used_pcnt, :decimal
    field :excess_margin, :integer
    field :available_margin, :integer
    field :withdrawable_margin, :integer
    field :timestamp, :utc_datetime_usec
  end

  def changeset(record, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(record, attrs, __MODULE__.__schema__(:fields))
  end
end
