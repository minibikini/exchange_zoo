defmodule Zoo.Binance.Model.AccountInfo do
  use Zoo.Model
  alias Zoo.Binance.Model.AccountInfo.{Asset, Position}

  @primary_key false

  embedded_schema do
    field :fee_tier, :integer
    field :can_trader, :boolean
    field :can_deposit, :boolean
    field :can_withdraw, :boolean
    field :update_time, :integer
    field :multi_assets_margin, :boolean
    field :total_initial_margin, :decimal
    field :total_maint_margin, :decimal
    field :total_wallet_balance, :decimal
    field :total_unrealized_profit, :decimal
    field :total_margin_balance, :decimal
    field :total_position_initial_margin, :decimal
    field :total_open_order_initial_margin, :decimal
    field :total_cross_wallet_balance, :decimal
    field :total_cross_un_pnl, :decimal
    field :available_balance, :decimal

    embeds_many :assets, Asset
    embeds_many :positions, Position
  end

  def changeset(account_info, attrs \\ %{}) do
    account_info
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:assets, :positions])
    |> cast_embed(:assets)
    |> cast_embed(:positions)
  end
end

defmodule Zoo.Binance.Model.AccountInfo.Asset do
  use Zoo.Model

  @primary_key false

  embedded_schema do
    field :asset, :string
    field :wallet_balance, :decimal
    field :unrealized_profit, :decimal
    field :margin_balance, :decimal
    field :maint_margin, :decimal
    field :initial_margin, :decimal
    field :position_initial_margin, :decimal
    field :open_order_initial_margin, :decimal
    field :cross_wallet_balance, :decimal
    field :cross_un_pnl, :decimal
    field :available_balance, :decimal
    field :max_withdraw_amount, :decimal
    field :margin_available, :boolean
    field :update_time, :decimal
  end

  def changeset(asset, attrs \\ %{}) do
    cast(asset, attrs, __MODULE__.__schema__(:fields))
  end
end

defmodule Zoo.Binance.Model.AccountInfo.Position do
  use Zoo.Model

  @primary_key false

  embedded_schema do
    field :symbol, :string
    field :initial_margin, :decimal
    field :maint_margin, :decimal
    field :unrealized_profit, :decimal
    field :position_initial_margin, :decimal
    field :open_order_initial_margin, :decimal
    field :leverage, :decimal
    field :isolated, :boolean
    field :entry_price, :decimal
    field :max_notional, :decimal
    field :bid_notional, :decimal
    field :ask_notional, :decimal
    field :position_side, Ecto.Enum, values: ~w(both long short)a
    field :position_amt, :decimal
    field :update_time, :integer
  end

  def changeset(position, attrs \\ %{}) do
    attrs = update_values(attrs, ["position_side"], &String.downcase/1)
    cast(position, attrs, __MODULE__.__schema__(:fields))
  end
end

