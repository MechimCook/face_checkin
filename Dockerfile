FROM elixir:1.16

RUN apt-get update && \
    apt-get install -y nodejs npm python3.11 python3.11-venv python3-pip cmake build-essential && \
    ln -sf python3.11 /usr/bin/python3

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get 
COPY config ./config
RUN mix compile

COPY . .

RUN python3.11 -m venv venv311 && \
    ./venv311/bin/pip install -r assets/requirements.txt
