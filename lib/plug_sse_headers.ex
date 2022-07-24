defmodule Plug.SSEHeaders do
  import Plug.Conn

  def init(opt), do: opt

  def call(conn, opt) do
    IO.inspect(opt[:front])

    case get_scheme() do
      :http ->
        conn
        |> put_resp_header("Access-Control-Allow-Origin", opt[:front])
        |> put_resp_header("Vary", "Origin")
        |> put_resp_header("Cache-Control", "no-cache")
        |> put_resp_header("connection", "keep-alive")
        |> put_resp_header("content-type", "text/event-stream")

      :https ->
        conn
        # |> put_resp_header("Access-Control-Allow-Origin", opt[:front])
        |> put_resp_header("connection", "keep-alive")
        |> put_resp_header("content-type", "text/event-stream")
    end
  end

  defp get_scheme() do
    port =
      System.get_env()
      |> Map.get("PORT", "4000")
      |> String.to_integer()
      |> IO.inspect()

    case port do
      4000 -> :http
      4001 -> :https
    end
  end
end
