defmodule ChatbotServer.Handler do
  def handle(request) do
    # as a pipeline: the output of the first function will be the output of the next one
    request
    |> parse
    |> log
    |> route |> format_response
  end

  def log(conv), do : IO.inspect conv

  def parse(request) do
    [method, path, _] = request |> String.split("\n") |> List.first |> String.split(" ")

    %{ method: method, path: path, resp_body: "", status : nil }
  end


  # Define the endpoints
  def route(conv), do : route(conv, conv.method, conv.path)

  def rout(conv, "GET", "/ask") do
    %{ conv | status:200, resp_body: "Response of the chat" }
  end

  def rout(conv, "GET", "/fetch") do
    %{ conv | status: 200, resp_body: "Response of fetching new data" }
  end

  def rout(conv, "GET", "/fetch" <> id) do
    %{ conv | status: 200, resp_body: "Response of fetching new data #{id}" }
  end

  def rout(conv, "DELETE", "/fetch" <> id) do
    %{ conv | status: 200, resp_body: "Deleting data" }
  end

  def rout(conv, "GET", "/train") do
    %{ conv | status: 200, resp_body: "Response of training the model" }
  end

  def route(conv, _method, path) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end


  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

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
