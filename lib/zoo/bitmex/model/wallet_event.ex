defmodule ExchangeZoo.BitMEX.Model.WalletEvent do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :account, :integer
    field :currency, :string
    field :deposited, :integer
    field :withdrawn, :integer
    field :transferIn, :integer
    field :transferOut, :integer
    field :amount, :integer
    field :pendingCredit, :integer
    field :pendingDebit, :integer
    field :confirmedDebit, :integer
    field :timestamp, :utc_datetime_usec
  end

  def changeset(record, attrs \\ %{}) do
    attrs = underscore_keys(attrs)
    cast(record, attrs, __MODULE__.__schema__(:fields))
  end
end
