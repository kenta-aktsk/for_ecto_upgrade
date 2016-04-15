# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

{_, osname} = :os.type()
if osname == :darwin && Mix.env == :dev do
  Mix.env(:local)
  System.put_env("MIX_ENV", Atom.to_string(Mix.env))
end

# Configures the endpoint
config :media_sample, MediaSample.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "SNGrdlPqi3howFc98AszYO2do73NM4UzDXQzk6rirQ6YHm9Gtq7cbjwkxgXZN/Aw",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: MediaSample.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :media_sample, MediaSample.Gettext,
  locales: ~w(ja en),
  default_locale: "en"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [uid_field: "login"]},
    facebook: {Ueberauth.Strategy.Facebook, []},
    twitter: {Ueberauth.Strategy.Twitter, []},
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]}
  ]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :arc,
  storage: Arc.Storage.S3,
  base_upload_path: "uploads"

config :guardian, Guardian,
  issuer: "MediaSample",
  ttl: { 3, :days },
  verify_issuer: true,
  serializer: MediaSample.GuardianSerializer

config :plug_session_memcached,
  server: ['127.0.0.1', 11211]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
