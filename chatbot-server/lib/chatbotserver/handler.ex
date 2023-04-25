defmodule ChatbotServer.Handler do
  def handle(request) do
    # as a pipeline: the output of the first function will be the output of the next one
    request |> parse |> route |> format_response
  end

  def parse(request) do
    conv = %{ method: "GET", path: "/ask", resp_body: "" }
  end

  def route(request) do
    conv = %{ method: "GET", path: "/ask", resp_body: "Response of the chat" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Response of the chat
    """
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