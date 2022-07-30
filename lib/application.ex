defmodule SSE.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    plug_options = [
      port: app_port(),
      compress: true,
      cipher_suite: :strong,
      certfile: "priv/cert/sse+2.pem",
      keyfile: "priv/cert/sse+2-key.pem",
      otp_app: :sse,
      protocol_options: [idle_timeout: :infinity],
      verify: :verify_peer
    ]

    children = [
      # {Plug.Cowboy, scheme: :https, plug: SSE.Router, options: plug_options},
      {Plug.Cowboy,
       scheme: :http,
       plug: SSE.Router,
       options: [port: app_port(), protocol_options: [idle_timeout: :infinity]]},
      {Phoenix.PubSub, name: SSE.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SSE.Supervisor)
  end

  defp app_port do
    System.get_env()
    |> Map.get("PORT", "4043")
    |> String.to_integer()
  end
end
