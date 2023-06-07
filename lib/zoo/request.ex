defmodule ExchangeZoo.Request do
  def perform(request, mod, error_mod \\ nil, decoder \\ &decode/2) do
    with {:ok, %Finch.Response{status: 200} = response} <- Finch.request(request, ExchangeZoo.Finch) do
      decoder.(response.body, mod)
    else
      {:ok, %Finch.Response{} = response} ->
        decoder.(response.body, error_mod)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def decode(body, mod) do
    case Jason.decode(body) do
      {:ok, data} -> {:error, model_from_data(data, mod)}
      {:error, _reason} -> {:error, body}
    end
  end

  def model_from_data(data, nil), do: data

  def model_from_data(data, mod) when is_list(data) do
    Enum.map(data, &mod.from!/1)
  end

  def model_from_data(data, mod) when is_map(data) do
    mod.from!(data)
  end

  def add_header(%Finch.Request{} = request, key, value) do
    %{request | headers: [{key, value} | request.headers]}
  end

  def put_header_signature(%Finch.Request{} = request, header_key, secret_key, payload \\ fn request -> "#{request.query}#{request.body}" end) do
    signature = sign_payload(payload.(request), secret_key)
    add_header(request, header_key, signature)
  end

  def put_query_signature(%Finch.Request{} = request, query_key, secret_key, payload \\ fn request -> "#{request.query}#{request.body}" end) do
    signature = sign_payload(payload.(request), secret_key)
    signature_param = URI.encode_query(%{query_key => signature})

    query =
      if is_nil(request.query) || request.query == "" do
        signature_param
      else
        "#{request.query}&#{signature_param}"
      end

    %{request | query: query}
  end

  def append_query_params(%URI{} = uri, opts) do
    URI.append_query(uri, URI.encode_query(opts))
  end

  # TODO: Put this in an HMAC module, or something so in the
  # future we can make more modular for other exchanges.
  def sign_payload(payload, secret_key) do
    :crypto.mac(:hmac, :sha256, secret_key, payload)
    |> Base.encode16(case: :lower)
  end
end
