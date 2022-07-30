defmodule SSE.Router do
  @moduledoc false
  import Plug.Conn
  use Plug.Router
  require Logger

  defmodule SSEvent do
    defstruct [:event, :data, :id, :retry]
  end

  def stringify(message, data, id, retry) do
    %SSEvent{event: message, data: data, id: id, retry: retry}
  end

  # two allowed front-ends: one local-dev, one compiled online via Surge
  @front1 "https://localhost:4043"
  @front2 "https://valtio-demo.surge.sh"
  @front3 "http://localhost:3000"

  plug(:match)
  # plug(Plug.SSEHeaders)
  plug(CORSPlug, origin: [@front1, @front2, @front3])
  plug(Plug.SSL, rewrite_on: [:x_forwarded_host, :x_forwarded_port, :x_forwarded_proto])
  plug(Plug.Parsers, parsers: [:json], pass: ["text/*", "application/json"], json_decoder: Jason)
  plug(:dispatch)

  post "/post" do
    with params <- conn.params,
         data <- Jason.encode!(params),
         msg <- set_message(data) do
      Phoenix.PubSub.broadcast(SSE.PubSub, "post", {:post, msg})
      conn |> resp(303, "broadcasted") |> send_resp()
    end
  end

  get "/post" do
    Phoenix.PubSub.subscribe(SSE.PubSub, "post")

    conn = set_sse_headers(conn)

    receive do
      {:post, data} ->
        chunk(conn, data)
    end

    conn
  end

  get "/sse" do
    set_sse_headers(conn)
    |> send_letter
  end

  defp send_letter(conn, x \\ "a") do
    msg = Jason.encode!(%{msg: x}) |> set_message()
    {:ok, _conn} = chunk(conn, msg)
    :timer.sleep(5_000)

    send_letter(conn, get_random())
  end

  @doc """
  Alternative: use a function plug instead of module plug
  """
  def set_sse_headers(conn) do
    conn
    |> Plug.Conn.put_resp_header("connection", "keep-alive")
    |> Plug.Conn.put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
  end

  defp set_message(data) do
    uuid = Uuider.uuid4()
    "event: message\ndata: #{data}\nid: #{uuid}\nretry: 6000\n\n"
  end

  defp get_random() do
    Enum.map(?a..?z, fn x -> <<x::utf8>> end)
    |> Enum.random()
  end
end
