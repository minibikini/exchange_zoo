defmodule ExchangeZoo.Bybit.Model.WalletEvent do
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

  def changeset(wallet_event, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    wallet_event
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:coin])
    |> cast_embed(:coin)
  end
end
