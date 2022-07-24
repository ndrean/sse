import Config

config :sse,
  url: [
    scheme: "https",
    host: "safe-brushlands-81462.herokuapp.com",
    port: 443
  ],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]
