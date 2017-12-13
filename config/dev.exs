use Mix.Config

config :logger, :console, format: "$time $metadata[$level] $message\n"
config :logger, backends: [{TelegramLoggerBackend.Logger, :error}, :console]
