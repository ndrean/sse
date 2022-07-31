# defmodule Test do
#   @moduledoc false
#   require Logger
#   @timeout 20_000

#   @headers [{"Content-Type", "application/json"}]
#   @url_post "http://localhost:4043/post"
#   @url_sse "http://localhost:4043/sse"
#   # @options [{:max_redirect, 100}]

#   def send(text \\ "ok") do
#     Phoenix.PubSub.subscribe(SSE.PubSub, "post")
#     {:ok, msg} = Jason.encode(%{test: text})

#     case HTTPoison.post!(@url_post, msg, @headers) do
#       %HTTPoison.Response{status_code: code} ->
#         code
#     end
#   end

#   def received(text) do
#     case send(text) do
#       303 ->
#         receive do
#           {:post, data} ->
#             regexme(data)
#         end
#     end
#   end

#   defp regexme(text) do
#     text |> String.split("\n") |> Enum.at(1) |> String.split(" ") |> Enum.at(1) |> Jason.decode!()
#   end

#   defp receiver(m, pid) do
#     receive do
#       %HTTPoison.AsyncChunk{chunk: chunk} ->
#         data = regexme(chunk)
#         m = [data["msg"] | m]
#         IO.inspect(pid)
#         Logger.info(m)
#         receiver(m, pid)
#     end
#   end

#   def sse_receiver(time) do
#     m = []

#     Task.start(fn ->
#       Logger.info("starting test")

#       {:ok, pid} =
#         Task.start(fn ->
#           HTTPoison.get!(@url_sse, [],
#             recv_timeout: :infinity,
#             stream_to: self(),
#             max_redirect: 100
#           )

#           receiver(m, self())
#         end)

#       Process.sleep(time)
#       Logger.info("end of test")
#       Process.exit(pid, :kill)
#     end)
#   end

#   # def async_sse_receiver(time) do
#   #   Task.async(fn ->
#   #     :poolboy.transaction(
#   #       :worker,
#   #       fn pid ->
#   #         try do
#   #           GenServer.call(pid, {:load_users, time})
#   #         catch
#   #           e, r ->
#   #             IO.inspect("poolboy transaction caught error: #{inspect(e)}, #{inspect(r)}")
#   #             :ok
#   #         end
#   #       end,
#   #       @timeout
#   #     )
#   #   end)
#   # end

#   def start(number, time) do
#     # poolboy version
#     # 1..number
#     # |> Enum.map(fn _i -> async_sse_receiver(time) end)
#     # |> Enum.each(fn task -> await_and_inspect(task) end)

#     # for i <- 1..number do
#     1..number
#     |> Enum.map(fn _ ->
#       sse_receiver(time)
#       Process.sleep(100)
#     end)
#   end

#   # defp await_and_inspect(task), do: task |> Task.await(@timeout) |> IO.inspect()
# end
