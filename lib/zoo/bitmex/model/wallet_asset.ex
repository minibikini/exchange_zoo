defmodule ExchangeZoo.BitMEX.Model.WalletAsset do
  use ExchangeZoo.Model
  alias ExchangeZoo.BitMEX.Model.WalletAsset.Network

  @primary_key false

  embedded_schema do
    field :asset, :string
    field :currency, :string
    field :major_currency, :string
    field :name, :string
    field :currency_type, :string
    field :scale, :integer
    field :enabled, :boolean
    field :is_margin_currency, :boolean

    embeds_many :networks, Network
  end

  def changeset(wallet_asset, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    wallet_asset
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:networks])
    |> cast_embed(:networks)
  end
end

defmodule ExchangeZoo.BitMEX.Model.WalletAsset.Network do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :asset, :string
    field :token_address, :string
    field :deposit_enabled, :boolean
    field :withdrawal_enabled, :boolean
    field :withdrawal_fee, :integer
    field :min_fee, :integer
    field :max_fee, :integer
  end

  def changeset(network, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(network, attrs, __MODULE__.__schema__(:fields))
  end
end
