import Config

config :sse, SSE.Router,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost"],
  https: [
    port: 443,
    cipher_suite: :strong,
    otp_app: :sse,
    keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
    certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
    # OPTIONAL Key for intermediate certificates:
    # cacertfile: System.get_env("INTERMEDIATE_CERTFILE_PATH")
  ]
