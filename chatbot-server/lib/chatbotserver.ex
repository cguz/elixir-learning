defmodule ChatbotServer do
  @moduledoc """
  Documentation for `ChatbotServer`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ChatbotServer.hello()
      :world

  """
  def hello(name) do
    "Hello, #{name}"
  end
end

IO.puts ChatbotServer.hello("Martin");
