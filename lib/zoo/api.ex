defmodule ExchangeZoo.API do
  @moduledoc """
  Conveniences for defining exchange REST APIs.

  ## Example

      defmodule ExchangeZoo.Binance.API do
        use ExchangeZoo.API, base_url: "https://fapi.binance.com"

        alias ExchangeZoo.Binance.Model

        endpoint :get, "/fapi/v1/assetIndex", Model.AssetIndex
        endpoint :get, "/fapi/v1/leverageBracke", Model.LeverageBracket
        ...
      end
  """

  @doc false
  defmacro __using__(opts) do
    base_url = Keyword.fetch!(opts, :base_url)

    # ["ExchangeZoo", parent_module | _] = Module.split(definition)
    # request_module = String.to_atom("ExchangeZoo.#{parent_module}.Request")

    quote do
      import ExchangeZoo.API

      # TODO: Somehow import this so we don't have to explicitly include
      # Request module but somehow we need to figure out how to handle the fact
      # that the module code isn't compiled yet when we unquote.
      #
      # import unquote(request_module)

      @base_url unquote(base_url)

      defp build_url!(path, opts) do
        opts = Keyword.merge([uri: @base_url], opts)
        URI.new!(opts[:uri] <> path)
      end
    end
  end

  @doc """
  Defines an endpoint function with the given method and URL.

  ## Examples

      endpoint :get, "/v5/instrumentsInfo"
      endpoint :post, "/v1/order", as: :create_order
  """
  defmacro endpoint(method, path, model, opts \\ []) do
    fun_name =
      Keyword.get_lazy(opts, :as, fn ->
        to_function_name(method, path)
      end)

    quote do
      def unquote(fun_name)(params \\ [], opts \\ []) do
        build_url!(unquote(path), opts)
        |> append_query_params(params)
        |> perform_public(unquote(method), unquote(model))
      end
    end
  end

  defp to_function_name(method, path) do
    prefix = method_to_prefix(method)

    name =
      path
      |> String.split("/")
      |> List.last()
      |> String.replace("-", "_")
      |> Macro.underscore()

    String.to_atom("#{prefix}_#{name}")
  end

  defp method_to_prefix(:post), do: "create"
  defp method_to_prefix(method), do: method
end
