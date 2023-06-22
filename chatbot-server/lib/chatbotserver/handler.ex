defmodule ChatbotServer.Handler do

  @moduledoc """
  Handles HTTP requests.
  """
  # Constant values
  @pages_path Path.expand("../../pages", __DIR__)

  alias ChatbotServer.Conv

  import ChatbotServer.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import ChatbotServer.Parser
  import ChatbotServer.FileHandler, only: [handle_file: 2]

  @doc "Transforms the request into a response."
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

  # Define the endpoints
  #def route(conv) do
  #  route(conv, conv.method, conv.path)
  #end

  def route(%Conv{ method: "GET", path: "/ask"} = conv) do
    %{ conv | status: 200, resp_body: "Response of the chat" }
  end

  def route(%Conv{ method: "GET", path: "/fetch"} = conv) do
    %{ conv | status: 200, resp_body: "Response of fetching new data" }
  end

  def route(%Conv{ method: "GET", path: "/fetch/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Response of fetching new data #{id}" }
  end

  def route(%Conv{ method: "DELETE", path: "/fetch/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Deleting data #{id}" }
  end

  def route(%Conv{ method: "GET", path: "/train"} = conv) do
    %{ conv | status: 200, resp_body: "Response of training the model" }
  end




  def route(%Conv{ method: "GET", path: "/chat/ask"} = conv) do
    call_html_file("form.html")
    |> handle_file(conv)
  end

  # solution with pattern matching and functions
  def route(%Conv{ method: "GET", path: "/about"} = conv) do
    # convert the directory relative to the current directory
    call_html_file("about.html")
    |> handle_file(conv)
  end

  def call_html_file(file) do
    @pages_path
    |> Path.join(file)
    |> File.read
  end


  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end


  # So using byte_size is a more accurate way to calculate the length of the response body.
  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end

request = """
GET /chat/ask HTTP/1.1
Host: example.com
User-Agent: ExambleBrowser/1.0
Accept: */*

"""

response = ChatbotServer.Handler.handle(request)

IO.puts response


request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExambleBrowser/1.0
Accept: */*

"""

response = ChatbotServer.Handler.handle(request)

IO.puts response
