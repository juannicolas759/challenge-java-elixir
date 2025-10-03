import Config

config :challenge_elixir,
  timezone: "America/Bogota",
  env: :prod,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "challenge_elixir"

config :logger,
  level: :warning
