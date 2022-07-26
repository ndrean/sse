defmodule SSE.Application do
  use Application

  def start(_type, _args) do
    #   case app_port() do
    #     4000 ->
    plug_options = [
      #   port: app_port(),
      #   compress: false,
      #   protocol_options: [idle_timeout: :infinity]
      # ]

      #     4001 ->
      #       [
      port: 4043,
      cipher_suite: :strong,
      certfile: "priv/cert/selfsigned.pem",
      keyfile: "pr/iv/cert/selfsigned_key.pem",
      otp_app: :sse,
      # password: "SECRET",
      protocol_options: [idle_timeout: :infinity]
    ]

    #     443 ->
    #       [port: 443, protocol_options: [idle_timeout: :infinity]]
    #   end

    # scheme =
    #   case app_port() do
    #     4000 -> :http
    #     4001 -> :https
    #     443 -> :heroku
    #   end

    children = [
      # {Plug.Cowboy, scheme: :http, plug: SSE.Router, options: plug_options},
      {Plug.Cowboy, scheme: :https, plug: SSE.Router, options: plug_options},
      PubSub
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SSE.Supervisor)
  end

  defp app_port do
    System.get_env()
    |> Map.get("PORT", "4000")
    # default value
    |> String.to_integer()
  end
end
