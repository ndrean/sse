# Sse

The Elixir code tests works only in HTTP mode, but `curl` works for both.
To change mode, select in "Application" between the two setups:

```elixir
#Application
{Plug.Cowboy, scheme: :https, plug: SSE.Router, options: plug_options},
{Plug.Cowboy, scheme: :http,...}
```

In `Router`, you have to declare the client endpoints for CORS.
Client side, you have to select also the endpoint whether HTTP or HTTPS (in .ENV)

The Docker image works locally on HTTPS. It needs some modifications to be able to deploy.

For HTTP/1.1 between <http://localhost:4000/sse> and <http://localhost:3000>, run:

```bash
PORT 4000 mix run --no-halt
```

For TLS HTTP/2, between self-signed <https://localhost:4000/sse> and <https://demo-valtio.surge.sh>, run:

```bash
PORT=4000 mix run --no-halt
```

Used `mkcert` for self-signed certificats

```bash
# run this one
curl -v https://localhost:4043/sse

# then run this one
curl -X POST -H "content-type: application/json" -d '{"test": "hello Amy"}' https://localhost:4043/post
```

Caddy is ready.
