defmodule Mix.Tasks.Zoo.Gen.Event do
  @shortdoc "Generates an Event"

  @moduledoc """
  Generates boilerplate code for a WebSocket Event.

      $ mix zoo.gen.event Exchange AccountUpdate --example=example.json

  Accepts the module name for the exchange, a request method and the event. A
  JSON file of an example response can be given to infer the model attributes.

  The generated files will contain:

    * a model `lib/zoo/exchange/model/account_update_event.ex`
    * a fixture `test/support/fixtures/exchange/events/account_update_event.json`
  """

  use Mix.Task

  def run(_opts) do
    # TODO
  end
end
