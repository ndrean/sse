defmodule SSE.Router do
  import Plug.Conn
  use Plug.Router

  # @front "https://demo-valtio.surge.sh"
  @front1 "http://localhost:3000"
  @front2 "https://valtio-demo.surge.sh"

  plug(:match)
  plug(Plug.SSEHeaders)
  plug(CORSPlug, origin: [@front1, @front2])
  plug(Plug.SSL, rewrite_on: [:x_forwarded_host, :x_forwarded_port, :x_forwarded_proto])

  plug(Plug.Parsers, parsers: [:json], pass: ["text/*", "application/json"], json_decoder: Jason)
  plug(:dispatch)

  post "/post" do
    data = Jason.encode!(conn.params)
    uuid = Uuider.uuid4()
    msg = "event: message\ndata: #{data}\nid: #{uuid}\nretry: 6000\n\n"
    Phoenix.PubSub.broadcast(SSE.PS, "post", {:post, msg})
    conn |> resp(303, "broadcasted") |> send_resp()
  end

  get "/post" do
    Phoenix.PubSub.subscribe(SSE.PS, "post")

    conn =
      conn
      |> send_chunked(200)

    receive do
      {:post, data} ->
        chunk(conn, data)
    end

    conn
  end

  get "/sse" do
    conn
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
