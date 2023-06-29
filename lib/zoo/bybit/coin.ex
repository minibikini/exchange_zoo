defmodule ExchangeZoo.Bybit.Model.Coin do
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

  def changeset(coin, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    cast(coin, attrs, __MODULE__.__schema__(:fields))
  end
end
