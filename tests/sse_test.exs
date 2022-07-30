defmodule SSETest do
  @moduledoc false
  use ExUnit.Case


  test "is posted" do
    assert Messages.check_posted() === 303
  end

  test "PubSubing" do
    assert Messages.received("hi") === %{"test" => "hi"}
    end
  end
end
