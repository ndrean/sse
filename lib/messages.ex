defmodule Messages do
  @moduledoc false
  require Logger

  @headers [{"Content-Type", "application/json"}]
  @url_post "http://localhost:4043/post"
  @url_sse "http://localhost:4043/sse"

  def send(text \\ "ok") do
    Phoenix.PubSub.subscribe(SSE.PubSub, "post")
    {:ok, msg} = Jason.encode(%{test: text})
    HTTPoison.post!(@url_post, msg, @headers)
  end

  def check_posted(text \\ "ok") do
    case send(text) do
      %HTTPoison.Response{status_code: code} ->
        code
    end
  end

  def received(text) do
    case check_posted(text) do
      303 ->
        receive do
          {:post, data} ->
            regexme(data)
        end
    end
  end

  defp regexme(text) do
    text |> String.split("\n") |> Enum.at(1) |> String.split(" ") |> Enum.at(1) |> Jason.decode!()
  end

  defp chunker(m) do
    receive do
      %HTTPoison.AsyncChunk{chunk: chunk} ->
        data = regexme(chunk)
        m = [data["msg"] | m]
        IO.inspect(m)
        chunker(m)
    end
  end

  def catch_sse() do
    m = []

    Task.start(fn ->
      HTTPoison.get!(@url_sse, [], recv_timeout: :infinity, stream_to: self())
      chunker(m)
    end)
  end
end
