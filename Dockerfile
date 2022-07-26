FROM  bitwalker/alpine-elixir:latest AS build
WORKDIR /opt/app
RUN mix do local.hex --force, local.rebar --force
COPY mix.exs mix.lock ./
COPY config /.config
ARG MIX_ENV=${MIX_ENV:-prod}
RUN mix do deps.get --only $MIX_ENV && mix deps.compile
COPY lib ./lib
COPY priv ./priv
COPY rel ./rel
ARG BUILD_NAME=sse
RUN mix release $BUILD_NAME --quiet

FROM alpine:latest AS app
ARG MIX_ENV=${MIX_ENV:-prod}

ENV PORT=4043
WORKDIR /opt/app
RUN apk --update --no-cache add bash grep openssl ncurses-libs tini libstdc++ libgcc
RUN chown -R nobody: /opt/app
USER nobody

ENV HOME=/app
ENV BUILD_NAME=sse
COPY --from=build /opt/app/_build/${MIX_ENV}/rel/${BUILD_NAME} ./

ENTRYPOINT ["./bin/sse"]
CMD [ "start","--no-halt" ]