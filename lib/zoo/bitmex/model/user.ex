defmodule ExchangeZoo.BitMEX.Model.User do
  use ExchangeZoo.Model
  alias ExchangeZoo.BitMEX.Model.User.Preferences

  @primary_key false

  embedded_schema do
    field :id, :integer
    field :firstname, :string
    field :lastname, :string
    field :username, :string
    field :account_name, :string
    field :is_user, :boolean
    field :email, :string
    field :date_of_birth, :string
    field :phone, :string
    field :created, :utc_datetime_usec
    field :last_updated, :utc_datetime_usec
    field :tfa_enabled, :string
    field :affiliate_id, :string
    field :country, :string
    field :geoip_country, :string
    field :geoip_region, :string
    field :first_trade_timestamp, :utc_datetime_usec
    field :first_deposit_timestamp, :utc_datetime_usec
    field :typ, :string

    embeds_one :preferences, Preferences
  end

  def changeset(record, attrs \\ %{}) do
    attrs = underscore_keys(attrs)

    record
    |> cast(attrs, __MODULE__.__schema__(:fields) -- [:preferences])
    |> cast_embed(:preferences)
  end
end

defmodule ExchangeZoo.BitMEX.Model.User.Preferences do
  use ExchangeZoo.Model

  @primary_key false

  embedded_schema do
    field :alert_on_liquidations, :boolean
    field :animations_enabled, :boolean
    field :announcements_last_seen, :utc_datetime_usec
    field :chat_channel_id, :integer
    field :color_theme, :string
    field :currency, :string
    field :debug, :boolean
    field :disable_emails, {:array, :string}
    field :disable_push, {:array, :string}
    field :display_corp_enroll_upsell, :boolean
    field :equivalent_currency, :string
    field :features, {:array, :string}
    field :favourites, {:array, :string}
    field :favourites_assets, {:array, :string}
    field :favourites_ordered, {:array, :string}
    field :favourite_bots, {:array, :string}
    field :has_set_trading_currencies, :boolean
    field :hide_confirm_dialogs, {:array, :string}
    field :hide_connection_modal, :boolean
    field :hide_from_leaderboard, :boolean
    field :hide_name_from_leaderboard, :boolean
    field :hide_pnl_in_guilds, :boolean
    field :hide_roi_in_guilds, :boolean
    field :hide_notifications, {:array, :string}
    field :hide_phone_confirm, :boolean
    field :is_sensitive_info_visible, :boolean
    field :is_wallet_zero_balance_hidden, :boolean
    field :locale, :string
    field :locale_set_time, :integer
    field :margin_pnl_row, :string
    field :margin_pnl_row_kind, :string
    field :mobile_locale, :string
    field :msgs_seen, {:array, :string}
    field :notifications, :map
    field :options_beta, :boolean
    field :order_book_binning, :map
    field :order_book_type, :string
    field :order_clear_immediate, :boolean
    field :order_controls_plus_minus, :boolean
    field :platform_layout, :string
    field :selected_fiat_currency, :string
    field :show_chart_bottom_toolbar, :boolean
    field :show_locale_numbers, :boolean
    field :sounds, {:array, :string}
    field :spacing_preference, :string
    field :strict_ip_check, :boolean
    field :strict_timeout, :boolean
    field :ticker_group, :string
    field :ticker_pinned, :boolean
    field :trade_layout, :string
    field :user_color, :string
  end

  def changeset(instrument, attrs \\ %{}) do
    cast(instrument, attrs, __MODULE__.__schema__(:fields))
  end
end

