import Config

config :sse, SSE.Router,
  http: [port: 4000],
  protocol_options: [idle_timeout: :infinity],
  https: [
    port: 443,
    cipher_suite: :strong,
    certfile: "priv/cert/sse+2.pem",
    keyfile: "priv/cert/sse+2-key.pem",
    otp_app: :sse
  ]

# force_ssl: [rewrite_on: [:x_forwarded_proto]]
