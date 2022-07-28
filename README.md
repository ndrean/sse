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

Use `mkcert` for self-signed certificats

SECRET_KEY_BASE=xvafzY4y01jYuzLm3ecJqo008dVnU3CN4f+MamNd1Zue4pXvfvUjbiXT8akaIF53

```bash
docker build -t sse .
docker run -p 4000:4000 -it --rm sse
```

```bash
# run this one
curl -v https://localhost:4043/sse

# then run this one
curl -X POST -H "content-type: application/json" -d '{"test": "hello Amy"}' https://localhost:5043/post
```
