defmodule Mix.Tasks.Zoo.Gen.Endpoint do
  @shortdoc "Generates an Endpoint"

  @moduledoc """
  Generates boilerplate code for an API Endpoint.

      $ mix zoo.gen.endpoint Exchange GET /v1/api/exchangeInfo --example=example.json

  Accepts the module name for the exchange, a request method, and the URL for
  the endpoint.  A JSON file of an example response can be given to infer the
  model attributes.

  The generated files will contain:

    * a model `lib/zoo/exchange/model/exchange_info.ex`
    * a fixture `test/support/fixtures/exchange/v1_api_exchangeInfo.json`
  """
end
