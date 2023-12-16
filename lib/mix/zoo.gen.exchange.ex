defmodule Mix.Tasks.Zoo.Gen.Exchange do
  @shortdoc "Generates an Exchange"

  @moduledoc """
  Generates boilerplate code for an Exchange.

      $ mix zoo.gen.exchange Exchange

  Accepts the module name for the exchange

  The generated files will contain:

    * a directory `lib/zoo/exchange`
    * a request module `lib/zoo/exchange/request.ex`
    * an error model `lib/zoo/exchange/model/error.ex`
    * an exchange test in `test/exchange_test.exs`

  """

  @switches [handle: :string]
  @default_opts []

  use Mix.Task

  alias Mix.Zoo.Exchange

  def run(args) do
    build(args)
  end

  def build(args) do
    {opts, parsed, _} = parse_opts(args)

    [exchange_name | _] = validate_args!(parsed)

    exchange_name
    |> Exchange.new(opts)
    |> copy_new_files()
  end

  @doc false
  def files_to_be_generated(%Exchange{} = exchange) do
    module_path = Path.join(["lib", "zoo", exchange.handle])
    # test_path = Path.join(["test", exchange.handle])

    [
      {"request.ex", Path.join([module_path, "request.ex"])}
    ]
  end

  @doc false
  def copy_new_files(%Exchange{} = exchange) do
    files = files_to_be_generated(exchange)
    Mix.Zoo.copy_from("priv/templates/zoo.gen.exchange", [exchange: exchange], files)

    exchange
  end

  defp parse_opts(args) do
    {opts, parsed, invalid} = OptionParser.parse(args, switches: @switches)

    merged_opts = Keyword.merge(@default_opts, opts)

    {merged_opts, parsed, invalid}
  end

  defp validate_args!([exchange_name | _] = args) do
    cond do
      not Exchange.valid?(exchange_name) ->
        raise_with_help(
          "Expected the exchange, #{inspect(exchange_name)}, to be a valid module name"
        )

      true ->
        args
    end
  end

  defp validate_args!(_) do
    raise_with_help("Invalid arguments")
  end

  @doc false
  @spec raise_with_help(binary) :: no_return
  def raise_with_help(msg) do
    Mix.raise("""
    #{msg}

    mix zoo.gen.exchange, zoo.gen.model, zoo.gen.endpoint, zoo.gen.event
    expect an exchange module name for the generated resource.

    For example:

        mix zoo.gen.exchange Binance
        mix zoo.gen.model Binance Error code:integer message:string
        mix zoo.gen.endpoint Binance /v1/exchangeInfo --example=example.json
        mix zoo.gen.event Binance mark_price_update --example=example.json
    """)
  end
end
