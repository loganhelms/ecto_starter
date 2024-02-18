defmodule EctoStarterTest do
  use ExUnit.Case
  doctest EctoStarter

  test "greets the world" do
    assert EctoStarter.hello() == :world
  end
end
