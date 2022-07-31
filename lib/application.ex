defmodule SSE.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    https_options = [
      port: app_port(),
      compress: true,
      cipher_suite: :strong,
      certfile: "priv/cert/sse+2.pem",
      keyfile: "priv/cert/sse+2-key.pem",
      otp_app: :sse,
      protocol_options: [idle_timeout: :infinity]
    ]

    http_options = [
      port: app_port(),
      protocol_options: [idle_timeout: :infinity]
    ]

    children = [
      # {Plug.Cowboy, scheme: :https, plug: SSE.Router, options: https_options},
      {Plug.Cowboy, scheme: :http, plug: SSE.Router, options: http_options},
      {Phoenix.PubSub, name: SSE.PubSub}
      # :poolboy.child_spec(:worker, poolboy_config())
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SSE.Supervisor)
  end

  defp app_port do
    System.get_env()
    |> Map.get("PORT", "4043")
    |> String.to_integer()
  end

  # defp poolboy_config do
  #   [
  #     name: {:local, :worker},
  #     worker_module: Worker,
  #     size: 5,
  #     max_overflow: 2
  #   ]
  # end
end
