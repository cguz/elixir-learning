defmodule ChatbotServerTest do
  use ExUnit.Case
  doctest ChatbotServer

  test "greets the world" do
    assert ChatbotServer.hello() == :world
  end
end
