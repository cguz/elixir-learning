defmodule ChatbotServer.Conv do

  # The name of the struct is the same as the module ChatbotServer.Conv
  defstruct method: "", path: "", params: "", resp_body: "", status: nil

  # function to return the full status
  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  ## private function of the status reason
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
