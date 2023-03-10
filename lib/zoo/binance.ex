defmodule ExchangeZoo.API.Binance.FAPI do
  @base_url "https://fapi.binance.com"

  def get_account_info() do
    Finch.build(:get, @base_url <> "/fapi/v2/account")
    |> put_api_key()
    |> put_signature()
    |> Finch.request(ExchangeZoo.Finch)
  end

  def put_api_key(%Finch.Request{} = request, api_key \\ get_api_key()) do
    %{request | headers: [{"X-MBX-APIKEY", api_key} | request.headers]}
  end

  def put_signature(%Finch.Request{} = request, secret_key \\ get_secret_key()) do
    payload = "#{request.query}#{request.body}"

    signature =
      :crypto.mac(:hmac, :sha256, secret_key, payload)
      |> Base.encode16(case: :lower)

    %{request | query: request.query <> "&signature=#{signature}"}
  end

  defp get_api_key() do
    "your-api-key"
  end

  defp get_secret_key() do
    "your-secret-key"
  end
end
