defmodule ExchangeZoo.Bybit.Model.OrderList do
  use ExchangeZoo.Model
  alias ExchangeZoo.Bybit.Model.OrderList.Order

  @primary_key false

  @categories ~w(spot linear inverse option)a

  embedded_schema do
    field :category, Ecto.Enum, values: @categories
    field :next_page_cursor, :string

    embeds_many :list, Order
  end

  def changeset(order_list, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    order_list
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:list])
    |> cast_embed(:list)
  end
end

defmodule ExchangeZoo.Bybit.Model.OrderList.Order do
  use ExchangeZoo.Model

  @primary_key false

  @sides ~w(buy sell)a
  @order_statuses ~w(created new rejected partially_filled partially_filled_canceled filled cancelled untriggered triggered deactivated active)a
  @create_types ~w(create_by_user create_by_admin_closing create_by_stop_order create_by_take_profit create_by_partial_take_profit create_by_stop_loss create_by_partial_stop_loss create_by_trailing_stop create_by_liq create_by_take_over_pass_through_if create_by_adl_pass_through create_by_block_pass_through create_by_block_trade_move_position_pass_through create_by_closing create_by_f_grid_bot close_by_f_grid_bot create_by_twap create_by_tv_signal create_by_mm_rate_close create_by_martingale_bot close_by_martingale_bot create_by_ice_berg create_by_arbitrage)a
  @cancel_types ~w(unknown cancel_by_user cancel_by_reduce_only cancel_by_prepare_liq cancel_all_before_liq cancel_by_prepare_adl cancel_all_before_adl cancel_by_admin cancel_by_tp_sl_ts_clear cancel_by_pz_side_ch cancel_by_smp)a
  @reject_reasons ~w(ec__no_error ec__others ec__unknown_message_type ec__missing_cl_ord_id ec__missing_orig_cl_ord_id ec__cl_ord_id_orig_cl_ord_id_are_the_same ec__duplicated_cl_ord_id ec__orig_cl_ord_id_does_not_exist ec__too_late_to_cancel ec__unknown_order_type ec__unknown_side ec__unknown_time_in_force ec__wrongly_routed ec__market_order_price_is_not_zero ec__limit_order_invalid_price ec__no_enough_qty_to_fill ec__no_immediate_qty_to_fill ec__per_cancel_request ec__market_order_cannot_be_post_only ec__post_only_will_take_liquidity ec__cancel_replace_order ec__invalid_symbol_status)a
  @time_in_forces ~w(gtc ioc fok post_only)a
  @order_types ~w(unknown market limit)a
  @stop_order_types ~w(unknown take_profit stop_loss trailing_stop stop partial_take_profit partial_stop_loss tpsl_order)a
  @oco_trigger_types ~w(oco_trigger_by_unknown oco_trigger_tp oco_trigger_by_sl)a
  @trigger_by ~w(unknown last_price index_price mark_price)a
  @place_types ~w(iv price)a
  @smp_types ~w(none cancel_maker cancel_taker cancel_both)a

  embedded_schema do
    field :order_id, :string
    field :order_link_id, :string
    field :block_trade_id, :string
    field :symbol, :string
    field :price, :decimal
    field :qty, :decimal
    field :side, Ecto.Enum, values: @sides
    field :is_leverage, Ecto.Enum, values: [false: 0, true: 1]
    field :position_idx, Ecto.Enum, values: [both: 0, buy: 1, sell: 2]
    field :order_status, Ecto.Enum, values: @order_statuses
    field :create_type, Ecto.Enum, values: @create_types
    field :cancel_type, Ecto.Enum, values: @cancel_types
    field :reject_reason, Ecto.Enum, values: @reject_reasons
    field :avg_price, :decimal
    field :leaves_qty, :decimal
    field :leaves_value, :decimal
    field :cum_exec_qty, :decimal
    field :cum_exec_value, :decimal
    field :cum_exec_fee, :decimal
    field :time_in_force, Ecto.Enum, values: @time_in_forces
    field :order_type, Ecto.Enum, values: @order_types
    field :stop_order_type, Ecto.Enum, values: @stop_order_types
    field :order_iv, :decimal
    field :trigger_price, :decimal
    field :take_profit, :decimal
    field :stop_loss, :decimal
    field :tpsl_mode, Ecto.Enum, values: ~w(full partial)a
    field :oco_trigger_type, Ecto.Enum, values: @oco_trigger_types
    field :tp_limit_price, :decimal
    field :sl_limit_price, :decimal
    field :tp_trigger_by, Ecto.Enum, values: @trigger_by
    field :sl_trigger_by, Ecto.Enum, values: @trigger_by
    field :trigger_direction, Ecto.Enum, values: [none: 0, rise: 1, fall: 2]
    field :trigger_by, Ecto.Enum, values: @trigger_by
    field :last_price_on_created, :decimal
    field :reduce_only, :boolean
    field :close_on_trigger, :boolean
    field :place_type, Ecto.Enum, values: @place_types
    field :smp_type, Ecto.Enum, values: @smp_types
    field :smp_group, :integer
    field :smp_order_id, :string
    field :created_time, :integer
    field :updated_time, :integer
  end

  def changeset(order, attrs \\ %{}) do
    attrs =
      attrs
      |> underscore_keys()
      |> prepare_enums(enum_fields() |> Enum.map(&to_string/1))

    cast(order, attrs, __MODULE__.__schema__(:fields))
  end
end
