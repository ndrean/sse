# Sse

For HTTP/1.1 between <http://localhost:4000/sse> and <http://localhost:3000>, run:

```bash
PORT 4000 mix run --no-halt
```

For TLS HTTP/2, between self-signed <https://localhost:4000/sse> and <https://demo-valtio.surge.sh>, run:

```bash
PORT 4001 mix run --no-halt
```

Note that you need to remove connection-specific header fields (such as "Vary", "Cache-Control" and "Access-Control-Allow-Origin")

```bash
iex -S mix
iex> Plug.Cowboy.http(SSE.Router, [], port: 4000, compress: true, protocol_options: [idle_timeout: :infinity])
```

Install `:x509` in the mix and run the following to geenrate self signed certificates

```bash
mix x509.gen.selfsigned
```
