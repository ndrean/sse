defmodule SSE.Application do
  use Application

  def start(_type, _args) do
    # plug_options =
    #   case app_port() do
    #     4000 ->
    #       [
    #         port: app_port(),
    #         compress: false,
    #         protocol_options: [idle_timeout: :infinity]
    #       ]

    #     4001 ->
    #       [
    #         port: 4001,
    #         cipher_suite: :strong,
    #         certfile: "priv/cert/selfsigned.pem",
    #         keyfile: "priv/cert/selfsigned_key.pem",
    #         otp_app: :sse,
    #         password: "SECRET"
    #       ]

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
      # {Plug.Cowboy, scheme: scheme, plug: SSE.Router, options: plug_options},
      {Plug.Cowboy,
       scheme: :https,
       plug: SSE.Router,
       options: [protocol_options: [idle_timeout: :infinity], port: 443]},
      PubSub
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SSE.Supervisor)
  end

  # defp app_port do
  #   System.get_env()
  #   |> Map.get("PORT", "4000")
  #   # default value
  #   |> String.to_integer()
  # end
end
