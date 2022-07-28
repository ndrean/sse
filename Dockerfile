FROM  bitwalker/alpine-elixir:latest AS build
# FROM elixir:1.13.4-alpine AS build
ARG BUILD_NAME=sse
WORKDIR /opt/app
RUN mix do local.hex --force, local.rebar --force
COPY mix.exs mix.lock ./
COPY config /.config
ARG MIX_ENV=${MIX_ENV:-prod}
RUN mix do deps.get --only $MIX_ENV && mix deps.compile
COPY lib ./lib
COPY priv ./priv
COPY rel ./rel/
RUN  mix release $BUILD_NAME --quiet


FROM alpine:latest AS app
ENV PORT=4043
WORKDIR /opt/app
RUN apk --update --no-cache add openssl ncurses-libs tini libstdc++ libgcc
RUN chown -R nobody: /opt/app
USER nobody
EXPOSE 4043
ENV HOME=/app
ENV BUILD_NAME=sse
ENV MIX_ENV=prod
COPY --from=build --chown=nobody:root /opt/app/_build/${MIX_ENV}/rel/${BUILD_NAME} ./

CMD ./bin/${BUILD_NAME} start