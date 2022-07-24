defmodule SSE.Application do
  use Application

  def start(_type, _args) do
    plug_options =
      case app_port() do
        4000 ->
          [
            port: app_port(),
            compress: false,
            protocol_options: [idle_timeout: :infinity]
          ]

        4001 ->
          [
            port: 4001,
            cipher_suite: :strong,
            certfile: "priv/cert/selfsigned.pem",
            keyfile: "priv/cert/selfsigned_key.pem",
            otp_app: :sse,
            password: "SECRET"
            # verify_fun: {&verify_fun_selfsigned_cert/3, []}
          ]
      end

    scheme =
      case app_port() do
        4000 -> :http
        4001 -> :https
      end

    children = [
      {Plug.Cowboy, scheme: scheme, plug: SSE.Router, options: plug_options}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SSE.Supervisor)
  end

  defp app_port do
    System.get_env()
    |> Map.get("PORT", "4000")
    |> String.to_integer()
  end
end
