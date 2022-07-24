defmodule SSE.Router do
  import Plug.Conn
  use Plug.Router

  @front "https://demo-valtio.surge.sh"
  # @front "http://localhost:3000"

  plug(Plug.SSEHeaders, front: @front)
  plug(:match)
  plug(:dispatch)

  get "/sse" do
    send_chunked(conn, 200) |> send_chunks()
  end

  defp send_chunks(conn) do
    Enum.map(?a..?z, fn x -> <<x::utf8>> end)
    |> Enum.map(fn t ->
      msg = "event: message\ndata: #{t}\nid: #{UUID.uuid4()}\n retry: 7000\n\n"
      chunk(conn, msg)
      :timer.sleep(5_000)
    end)

    send_chunks(conn)
  end
end
