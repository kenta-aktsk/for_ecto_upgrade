use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :for_ecto_upgrade, ForEctoUpgrade.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :for_ecto_upgrade, ForEctoUpgrade.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "myuser",
  password: "mypass",
  database: "for_ecto_upgrade_test",
  hostname: "localhost",
  charset: "utf8mb4",
  pool_size: 30,
  pool: Ecto.Adapters.SQL.Sandbox

config :guardian, Guardian,
  secret_key: System.get_env("MEDIA_SAMPLE_GUARDIAN_SECRET_KEY")
