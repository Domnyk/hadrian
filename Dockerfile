FROM bitwalker/alpine-elixir-phoenix:1.6.6

WORKDIR /hadrian
ADD . /hadrian

ENV MIX_ENV prod

RUN apk --update add postgresql-client
RUN npm install -g brunch
RUN cd ./assets && npm install && cd ..
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only dev
RUN mix ecto.create
RUN mix ecto.migrate
RUN cd ./assets && brunch build --production && cd ..
RUN mix phx.digest
RUN mix compile

CMD mix phx.server