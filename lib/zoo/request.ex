defmodule ExchangeZoo.Request do
  @type decoder() ::
          (Finch.Response.t(), module, module -> {:ok, term()} | {:error, integer(), any()})

  @spec perform(Finch.Request.t(), module, module | nil, decoder) ::
          {:ok, term()} | {:error, integer(), any()} | {:error, any()}
  def perform(request, mod, error_mod \\ nil, decoder \\ &decode/3) do
    case Finch.request(request, ExchangeZoo.Finch) do
      {:ok, response} ->
        decoder.(response, mod, error_mod)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def decode(%Finch.Response{status: 200} = response, mod, _error_mod) do
    case Jason.decode(response.body) do
      {:ok, data} -> {:ok, model_from_data(data, mod)}
      {:error, _reason} -> {:error, response.status, response.body}
    end
  end

  def decode(response, _mod, error_mod) do
    case Jason.decode(response.body) do
      {:ok, data} -> {:error, response.status, model_from_data(data, error_mod)}
      {:error, _reason} -> {:error, response.status, response.body}
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

  def put_header_signature(
        %Finch.Request{} = request,
        header_key,
        secret_key,
        payload \\ fn request -> "#{request.query}#{request.body}" end
      ) do
    signature = sign_payload(payload.(request), secret_key)
    add_header(request, header_key, signature)
  end

  def put_query_signature(
        %Finch.Request{} = request,
        query_key,
        secret_key,
        payload \\ fn request -> "#{request.query}#{request.body}" end
      ) do
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
