defmodule SSE.Router do
  import Plug.Conn
  use Plug.Router

  # @front "https://demo-valtio.surge.sh"
  @front "http://localhost:3000"

  plug(Plug.SSEHeaders, front: @front)
  plug(:match)
  plug(:dispatch)

  get "/sse" do
    PubSub.subscribe(self(), :event)
    send_chunked(conn, 200) |> send_chunks(self())
  end

  defp send_chunks(conn, pid) do
    Enum.map(?a..?z, fn x -> <<x::utf8>> end)
    |> Enum.map(fn t ->
      msg = "event: message\ndata: #{t}\nid:#{UUID.uuid4()}\n\n"

      {:ok, resp} = chunk(conn, msg)
      IO.inspect(resp.state)

      :timer.sleep(5_000)
    end)

    receive do
      {:event, data} ->
        msg = "event: message\ndata: #{data}\nid: #{UUID.uuid4()}\nretry: 7000\n\n"
        chunk(conn, msg)

      {:DOWN, _reference, :process, ^pid, _type} ->
        nil
    end

    send_chunks(conn, self())
  end
end
