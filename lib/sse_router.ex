defmodule SSE.Router do
  import Plug.Conn
  use Plug.Router

  # @front "https://demo-valtio.surge.sh"
  @front "http://localhost:3000"

  plug(:match)
  plug(Plug.SSEHeaders, front: @front)
  # plug(Plug.SSL)

  plug(Plug.Parsers, parsers: [:json], pass: ["text/*", "application/json"], json_decoder: Jason)
  plug(:dispatch)

  post "/post" do
    data = Jason.encode!(conn.params)
    uuid = Uuider.uuid4()
    msg = "event: message\ndata: #{data}\nid: #{uuid}\nretry: 6000\n\n"
    conn = send_chunked(conn, 200)

    {:ok, conn} = chunk(conn, msg)
    IO.inspect(conn.state, label: "posted SSE")
    conn
  end

  get "/sse" do
    conn
    # |> put_resp_header("connection", "keep-alive")
    # |> put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
    |> send_chunks()
  end

  defp send_chunks(conn) do
    Enum.map(?a..?z, fn x -> <<x::utf8>> end)
    |> Enum.map(fn t ->
      uuid = Uuider.uuid4()
      data = Jason.encode!(%{msg: t})
      msg = "event: message\ndata: #{data}\nid: #{uuid}\nretry: 6000\n\n"
      {:ok, resp} = chunk(conn, msg)
      IO.inspect(resp.state, label: "timed SSE")
      :timer.sleep(5_000)
    end)

    send_chunks(conn)
  end
end
