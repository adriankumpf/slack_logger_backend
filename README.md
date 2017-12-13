telegram_logger_backend
====================
[![Build Status](https://secure.travis-ci.org/craigp/telegram_logger_backend.png?branch=master "Build Status")](http://travis-ci.org/craigp/telegram_logger_backend)
[![Coverage Status](https://coveralls.io/repos/craigp/telegram_logger_backend/badge.svg?branch=master&service=github)](https://coveralls.io/github/craigp/telegram_logger_backend?branch=master)
[![hex.pm version](https://img.shields.io/hexpm/v/telegram_logger_backend.svg)](https://hex.pm/packages/telegram_logger_backend)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/telegram_logger_backend.svg)](https://hex.pm/packages/telegram_logger_backend)
[![Inline docs](http://inch-ci.org/github/craigp/telegram_logger_backend.svg?branch=master&style=flat)](http://inch-ci.org/github/craigp/telegram_logger_backend)

A logger backend for posting errors to telegram.

You can find the hex package [here](https://hex.pm/packages/telegram_logger_backend), and the docs [here](http://hexdocs.pm/telegram_logger_backend).

## Usage

First, add the client to your `mix.exs` dependencies:

```elixir
def deps do
  [{:telegram_logger_backend, "~> 0.0.1"}]
end
```

Then run `$ mix do deps.get, compile` to download and compile your dependencies.

Add the `:telegram_logger_backend` application as your list of applications in `mix.exs`:

```elixir
def application do
  [applications: [:logger, :telegram_logger_backend]]
end
```

Finally, add `telegramLoggerBackend.Logger` to your list of logging backends in your app's config:

```elixir
config :logger, backends: [telegramLoggerBackend.Logger, :console]
```

You can set the log levels you want posted to telegram in the config:

```elixir
config telegramLoggerBackend, :levels, [:debug, :info, :warn, :error]
```

Alternatively, do both in one step:

```elixir
config :logger, backends: [{telegramLoggerBackend.Logger, :error}]
config :logger, backends: [{telegramLoggerBackend.Logger, [:info, error]}]
```

You'll need to create a custom incoming webhook URL for your telegram team. You can either configure the webhook
in your config:

```elixir
config telegramLoggerBackend, :telegram, [url: "http://example.com"]
```

... or you can put the webhook URL in the `telegram_LOGGER_WEBHOOK_URL` environment variable if you prefer. If
you have both the environment variable will be preferred.

