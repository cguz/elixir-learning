defmodule ChatbotServer.Parser do

  alias ChatbotServer.Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %Conv{
      method: method,
      path: path
    }
  end

end
