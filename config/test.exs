use Mix.Config

config :bypass, enable_debug_log: false

config :logger, :console, format: "$time $metadata[$level] $message\n"
