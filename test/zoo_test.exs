defmodule ExchangeZooTest do
  use ExUnit.Case
  doctest ExchangeZoo

  test "greets the world" do
    assert ExchangeZoo.hello() == :world
  end
end
