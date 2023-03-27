defmodule ExchangeZoo.Binance.Model.LeverageBracket do
  use ExchangeZoo.Model
  alias ExchangeZoo.Binance.Model.LeverageBracket.Bracket

  @primary_key false

  embedded_schema do
    field :symbol, :string

    embeds_many :brackets, Bracket
  end

  def changeset(account_info, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    account_info
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:brackets])
    |> cast_embed(:brackets)
  end
end

defmodule ExchangeZoo.Binance.Model.LeverageBracket.Bracket do
  use ExchangeZoo.Model

  embedded_schema do
    field :bracket, :integer
    field :initial_leverage, :decimal
    field :notional_cap, :decimal
    field :notional_floor, :decimal
    field :maint_margin_ratio, :decimal
    field :cum, :decimal
  end

  def changeset(asset, attrs \\ %{}) do
    cast(asset, attrs, __MODULE__.__schema__(:fields))
  end
end
