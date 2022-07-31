# defmodule Worker do
#   @moduledoc false
#   use GenServer

#   def start_link(_) do
#     GenServer.start_link(__MODULE__, nil)
#   end

#   def init(_) do
#     {:ok, nil}
#   end

#   def handle_call({:load_users, time}, _from, _state) do
#     {:reply, Test.sse_receiver(time), nil}
#   end
# end
