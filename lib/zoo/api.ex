defmodule ExchangeZoo.API do
  @moduledoc """
  Conveniences for defining exchange REST APIs.

  * Imports ExchangeZoo.API and ExchangeZoo.__MODULE__.API
  * Sets @base_url and defines macros in example below.

  ## Example

      defmodule ExchangeZoo.Binance.API do
        use ExchangeZoo.API, base_url: "https://fapi.binance.com"

        alias ExchangeZoo.Binance.Model

        public :get, "/fapi/v1/assetIndex", Model.AssetIndex
        private :get, "/fapi/v1/leverageBracke", Model.LeverageBracket
        ...
      end
  """

  @doc false
  defmacro __using__(opts) do
    base_url = Keyword.fetch!(opts, :base_url)
    request_module =
      Keyword.get(opts, :request_module, infer_request_module(__CALLER__.module))

    quote do
      import ExchangeZoo.API
      import unquote(request_module)

      @base_url unquote(base_url)

      defp build_url!(path, opts) do
        opts = Keyword.merge([uri: @base_url], opts)
        URI.new!(opts[:uri] <> path)
      end
    end
  end

  @doc """
  Defines a public endpoint function with the given method and URL.

  ## Examples

      public :get, "/v5/instrumentsInfo"
      private :post, "/v1/order", as: :create_order
  """
  defmacro public(method, path, model, opts \\ []) do
    fun_name =
      Keyword.get_lazy(opts, :as, fn ->
        to_function_name(method, path)
      end)

    quote do
      def unquote(fun_name)(params \\ [], opts \\ []) do
        build_url!(unquote(path), opts)
        |> perform_public(unquote(method), params, unquote(model))
      end
    end
  end

  @doc """
  Defines a private endpoint function with the given method and URL.

  ## Examples

      private :post, "/v1/order", as: :create_order
  """
  defmacro private(method, path, model, opts \\ []) do
    fun_name = Keyword.get_lazy(opts, :as, fn -> to_function_name(method, path) end)

    quote do
      def unquote(fun_name)(params \\ [], opts \\ []) do
        build_url!(unquote(path), opts)
        |> perform_private(unquote(method), params, unquote(model), opts)
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
  defp method_to_prefix(:put), do: "update"
  defp method_to_prefix(method), do: method

  defp infer_request_module(module) do
    module
    |> Module.split()
    |> Enum.slice(0, 2)
    |> Kernel.++(["Request"])
    |> Module.concat()
  end
end
