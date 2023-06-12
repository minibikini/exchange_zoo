defmodule ExchangeZoo.Bybit.Model.WalletEvent do
  use ExchangeZoo.Model

  alias ExchangeZoo.Bybit.Model.WalletEvent.Coin

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

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    order
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:coin])
    |> cast_embed(:coin)
  end
end

defmodule ExchangeZoo.Bybit.Model.WalletEvent.Coin do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :coin, :string
    field :equity, :decimal
    field :usd_value, :decimal
    field :wallet_balance, :decimal
    field :free, :decimal
    field :locked, :decimal
    field :borrow_amount, :decimal
    field :available_to_borrow, :decimal
    field :available_to_withdraw, :decimal
    field :accrued_interest, :decimal
    field :total_order_im, :decimal
    field :total_position_im, :decimal
    field :total_position_mm, :decimal
    field :unrealised_pnl, :decimal
    field :cum_realised_pnl, :decimal
    field :bonus, :decimal
  end

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
