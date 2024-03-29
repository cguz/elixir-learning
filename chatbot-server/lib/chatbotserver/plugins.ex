defmodule ChatbotServer.Plugins do

  # create an alias to the struct
  alias ChatbotServer.Conv

  # The following functions only work if the input is an Conv struct
  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(%Conv{} = conv), do: conv

  # rewrite any path to another functional path
  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/nodefinedendpoint"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv
end
