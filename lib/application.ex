defmodule SSE.Application do
  use Application

  def start(_type, _args) do
    plug_options = [
      port: app_port(),
      compress: true,
      cipher_suite: :strong,
      certfile: "priv/cert/sse+2.pem",
      keyfile: "priv/cert/sse+2-key.pem",
      otp_app: :sse,
      # password: "SECRET",
      protocol_options: [idle_timeout: :infinity]
    ]

    children = [
      {Plug.Cowboy, scheme: :https, plug: SSE.Router, options: plug_options},
      {Phoenix.PubSub, name: SSE.PS}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SSE.Supervisor)
  end

  defp app_port do
    System.get_env()
    |> Map.get("PORT", "4043")
    |> String.to_integer()
  end
end
