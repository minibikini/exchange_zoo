defmodule ExchangeZoo.Request do
  def perform(request, mod) do
    with {:ok, %Finch.Response{status: 200} = response} <- Finch.request(request, ExchangeZoo.Finch),
         {:ok, data} <- Jason.decode(response.body) do
      {:ok, model_from_data(data, mod)}
    else
      {:ok, %Finch.Response{} = response} ->
        {:error, model_from_data(response.body, nil)}

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

  # TODO: Make this more generic, like an HMAC module, or something...
  def put_signature(%Finch.Request{} = request, secret_key) do
    payload = "#{request.query}#{request.body}"

    signature =
      :crypto.mac(:hmac, :sha256, secret_key, payload)
      |> Base.encode16(case: :lower)

    signature_param = URI.encode_query(signature: signature)

    query =
      if request.query == "" do
        "signature=#{signature_param}"
      else
        "#{request.query}&#{signature_param}"
      end

    %{request | query: query}
  end
end
