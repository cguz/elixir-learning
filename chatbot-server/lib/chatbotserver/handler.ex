defmodule ChatbotServer.Handler do
  def handle(request) do
    # as a pipeline: the output of the first function will be the output of the next one
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  # rewrite any path to another functional path
  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/nodefinedendpoint"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] = request |> String.split("\n") |> List.first |> String.split(" ")

    %{ method: method, path: path, resp_body: "", status: nil }
  end


  # Define the endpoints
  #def route(conv) do
  #  route(conv, conv.method, conv.path)
  #end

  def route(%{ method: "GET", path: "/ask"} = conv) do
    %{ conv | status: 200, resp_body: "Response of the chat" }
  end

  def route(%{ method: "GET", path: "/fetch"} = conv) do
    %{ conv | status: 200, resp_body: "Response of fetching new data" }
  end

  def route(%{ method: "GET", path: "/fetch/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Response of fetching new data #{id}" }
  end

  def route(%{ method: "DELETE", path: "/fetch/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Deleting data #{id}" }
  end

  def route(%{ method: "GET", path: "/train"} = conv) do
    %{ conv | status: 200, resp_body: "Response of training the model" }
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end


  # So using byte_size is a more accurate way to calculate the length of the response body.
  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end

  ## private function
  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /ask HTTP/1.1
Host: example.com
User-Agent: ExambleBrowser/1.0
Accept: */*

"""

response = ChatbotServer.Handler.handle(request)

IO.puts response
