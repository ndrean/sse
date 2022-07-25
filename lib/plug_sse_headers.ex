defmodule Plug.SSEHeaders do
  import Plug.Conn

  def init(opt), do: opt

  def call(conn, _opt) do
    # case get_scheme() do
    #   :http ->
    #     IO.inspect(opt[:front])

    #     conn
    #     |> put_resp_header("Access-Control-Allow-Origin", opt[:front])
    #     |> put_resp_header("Vary", "Origin")
    #     |> put_resp_header("Cache-Control", "no-cache")
    #     |> put_resp_header("connection", "keep-alive")
    #     |> put_resp_header("content-type", "text/event-stream")

    #   :https ->
    #     IO.puts("https")

    conn
    |> put_resp_header("connection", "keep-alive")
    |> put_resp_header("content-type", "text/event-stream")

    # end
  end

  # defp get_scheme() do
  #   port =
  #     System.get_env()
  #     |> Map.get("PORT", "4000")
  #     |> String.to_integer()
  #     |> IO.inspect()

  #   case port do
  #     4000 -> :http
  #     4001 -> :https
  #     443 -> :https
  #   end
  # end
end
