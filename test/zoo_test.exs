defmodule ZooTest do
  use ExUnit.Case
  doctest Zoo

  test "greets the world" do
    assert Zoo.hello() == :world
  end
end
