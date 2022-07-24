import Config

config :sse, SSE.Router,
  http: [port: 4000],
  # force_ssl: [hsts: true],
  https: [
    port: 4001,
    cipher_suite: :strong,
    certfile: "priv/cert/selfsigned.pem",
    keyfile: "priv/cert/selfsigned_key.pem",
    otp_app: :sse
  ]
