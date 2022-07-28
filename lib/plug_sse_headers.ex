defmodule Plug.SSEHeaders do
  import Plug.Conn

  def init(opt), do: opt

  def call(conn, _opt) do
    conn = assign(conn, :host, "0.0.0.0")
    IO.inspect(conn.host, label: "headers")

    conn
    # |> put_resp_header("Access-Control-Allow-Origin", opt[:front])
    # |> put_resp_header("Vary", "Origin")
    # |> put_resp_header("Cache-Control", "no-cache")
    |> put_resp_header("connection", "keep-alive")
    |> put_resp_header("content-type", "text/event-stream")
  end
end
