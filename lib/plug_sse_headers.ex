defmodule Plug.SSEHeaders do
  import Plug.Conn

  def init(opt), do: opt

  def call(conn, _opt) do
    conn
    |> assign(:host, "0.0.0.0")
    |> put_resp_header("connection", "keep-alive")
    |> put_resp_header("content-type", "text/event-stream")
  end
end
