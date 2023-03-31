defmodule ExchangeZoo.Request do
  def perform(request, mod, error_mod \\ nil) do
    with {:ok, %Finch.Response{status: 200} = response} <- Finch.request(request, ExchangeZoo.Finch),
         {:ok, data} <- Jason.decode(response.body) do
      {:ok, model_from_data(data, mod)}
    else
      {:ok, %Finch.Response{} = response} ->
        case Jason.decode(response.body) do
          {:ok, data} -> {:error, model_from_data(data, error_mod)}
          {:error, _reason} -> {:error, response.body}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp model_from_data(data, nil), do: data

  defp model_from_data(data, mod) when is_list(data) do
    Enum.map(data, &mod.from!/1)
  end

  defp model_from_data(data, mod) when is_map(data) do
    mod.from!(data)
  end

  def add_header(%Finch.Request{} = request, key, value) do
    %{request | headers: [{key, value} | request.headers]}
  end

  def put_signature(%Finch.Request{} = request, secret_key) do
    signature = sign_payload("#{request.query}#{request.body}", secret_key)
    signature_param = URI.encode_query(signature: signature)

    query =
      if request.query == "" do
        "signature=#{signature_param}"
      else
        "#{request.query}&#{signature_param}"
      end

    %{request | query: query}
  end

  # TODO: Put this in an HMAC module, or something so in the
  # future we can make more modular for other exchanges.
  def sign_payload(payload, secret_key) do
    :crypto.mac(:hmac, :sha256, secret_key, payload)
    |> Base.encode16(case: :lower)
  end
end
