FROM elixir:1.9.4-alpine

RUN mix local.hex --force \
    && apk --update add build-base postgresql-dev postgresql-client inotify-tools nodejs \
    && mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.3.ez \
    && mix local.rebar --force \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force \
    && mix deps.get

EXPOSE 4000
ENV MIX_ENV=prod

CMD [ "mix", "phx.server" ]