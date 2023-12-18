defmodule Mix.Tasks.Zoo.Gen.Event do
  @shortdoc "Generates an Event"

  @moduledoc """
  Generates boilerplate code for a WebSocket Event.

      $ mix zoo.gen.event Exchange Order
      $ mix zoo.gen.event Exchange AccountUpdate --example=example.json

  Accepts the module name for the exchange, a request method and the event. A
  JSON file of an example response can be given to infer the event attributes.

  The generated files will contain:

    * a event `lib/zoo/exchange/model/order_event.ex`
    * a fixture `test/support/fixtures/exchange/events/order_event.json`
  """

  @switches []
  @default_opts []

  use Mix.Task

  alias Mix.Zoo.{Exchange, Model}

  def run(args) do
    build(args)
  end

  def build(args) do
    {opts, parsed, _} = parse_opts(args)

    [exchange_name, event_name | attrs] = validate_args!(parsed)

    # Canonicalize the event name
    event_name = String.replace_suffix(event_name, "Event", "") <> "Event"

    exchange = Exchange.new(exchange_name, opts)
    model = Model.new(event_name, attrs)

    copy_new_files(exchange, model)
  end

  @doc false
  def copy_new_files(%Exchange{} = exchange, %Model{} = model) do
    fixture_path = Path.join(["test", "support", "fixtures", exchange.handle, "events"])
    Mix.Generator.create_directory(fixture_path)

    files = files_to_be_generated(exchange, model)
    Mix.Zoo.copy_from("priv/templates/zoo.gen.model", [exchange: exchange, model: model], files)

    exchange
  end

  defdelegate files_to_be_generated(exchange, model), to: Mix.Tasks.Zoo.Gen.Model

  defp parse_opts(args) do
    {opts, parsed, invalid} = OptionParser.parse(args, switches: @switches)

    merged_opts = Keyword.merge(@default_opts, opts)

    {merged_opts, parsed, invalid}
  end

  defp validate_args!([exchange_name, event_name | _] = args) do
    cond do
      not Exchange.valid?(exchange_name) ->
        raise_with_help(
          "Expected the exchange, #{inspect(exchange_name)}, to be a valid module name"
        )

      not Model.valid?(event_name) ->
        raise_with_help("Expected the event, #{inspect(event_name)}, to be a valid module name")

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

    mix zoo.gen.event expects both an exchange and event
    module name for the resource followed by any number of attributes:

        mix zoo.gen.event Binance Order symbol:string price:decimal quantity:decimal
        mix zoo.gen.event Binance AccountUpdate --example=example.json
    """)
  end
end
