defmodule ExchangeZoo.Bybit.Model.WalletBalanceList do
  use ExchangeZoo.Model
  alias ExchangeZoo.Bybit.Model.WalletBalanceList.WalletBalance

  @primary_key false

  embedded_schema do
    embeds_many :list, WalletBalance
  end

  def changeset(wallet_balance_list, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    wallet_balance_list
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:list])
    |> cast_embed(:list)
  end
end

defmodule ExchangeZoo.Bybit.Model.WalletBalanceList.WalletBalance do
  use ExchangeZoo.Model
  alias ExchangeZoo.Bybit.Model.Coin

  @primary_key false

  @account_types ~w(unified contract spot)a

  embedded_schema do
    field :account_type, Ecto.Enum, values: @account_types
    field :account_ltv, :decimal
    field :account_im_rate, :decimal
    field :account_mm_rate, :decimal
    field :total_equity, :decimal
    field :total_wallet_balance, :decimal
    field :total_margin_balance, :decimal
    field :total_available_balance, :decimal
    field :total_perp_upl, :decimal
    field :total_initial_margin, :decimal
    field :total_maintenance_margin, :decimal

    embeds_many :coin, Coin
  end

  def changeset(account, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    account
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:coin])
    |> cast_embed(:coin)
  end
end
