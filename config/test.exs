import Config

# Global config
config :ex_cldr,
  default_locale: "en-001",
  default_backend: TestBackend.Cldr

# Other configs
config :plug,
  validate_header_keys_during_test: true

config :logger,
  level: :warning,
  truncate: 4096
