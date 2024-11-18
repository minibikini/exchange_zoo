defmodule ExchangeZoo.Binance.Model.Kline do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :open_time, :integer
    field :close_time, :integer
    field :open, :decimal
    field :high, :decimal
    field :low, :decimal
    field :close, :decimal
    field :volume, :decimal
    field :quote_asset_volume, :decimal
    field :trades, :integer
    field :taker_buy_base_asset_volume, :decimal
    field :taker_buy_quote_asset_volume, :decimal
  end

  def changeset(kline, list) do
    attrs = list_to_attrs(list)
    cast(kline, attrs, __MODULE__.__schema__(:fields))
  end

  defp list_to_attrs([
         open_time,
         open,
         high,
         low,
         close,
         volume,
         close_time,
         quote_asset_volume,
         trades,
         taker_buy_base_asset_volume,
         taker_buy_quote_asset_volume,
         _ignore
       ]) do
    %{
      open_time: open_time,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
      close_time: close_time,
      quote_asset_volume: quote_asset_volume,
      trades: trades,
      taker_buy_base_asset_volume: taker_buy_base_asset_volume,
      taker_buy_quote_asset_volume: taker_buy_quote_asset_volume
    }
  end
end
