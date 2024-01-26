defmodule ExchangeZoo.BitMEX.Model.WalletNetwork do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :network, :string
    field :name, :string
    field :currency, :string
    field :network_symbol, :string
    field :transaction_explorer, :string
    field :token_explorer, :string
    field :deposit_confirmations, :integer
    field :enabled, :boolean
  end

  def changeset(wallet_network, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(wallet_network, attrs, __MODULE__.__schema__(:fields))
  end
end
