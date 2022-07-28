defmodule Uuider do
  def uuid4() do
    :uuid.get_v4()
    |> :uuid.uuid_to_string()
    |> List.to_string()
  end
end
