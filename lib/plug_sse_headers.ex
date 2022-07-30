defmodule Plug.SSEHeaders do
  @moduledoc """
  Module plug to set the required headers for SSE
  """
  import Plug.Conn

  def init(opt), do: opt

  def call(conn, _opt) do
    conn
    |> put_resp_header("connection", "keep-alive")
    |> put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
  end
end
