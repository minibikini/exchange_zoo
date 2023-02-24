defmodule Zoo.Fixtures do
  def json_fixture(name) do
    "test/support/fixtures/#{name}.json"
    |> File.read!()
    |> Jason.decode!()
  end
end
