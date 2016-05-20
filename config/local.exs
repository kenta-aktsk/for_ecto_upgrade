use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :media_sample, MediaSample.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :media_sample, MediaSample.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

config :media_sample, MediaSample.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "myuser",
  password: "mypass",
  database: "media_sample",
  hostname: "localhost",
  charset: "utf8mb4",
  pool_size: 10

config :media_sample, MediaSample.ReadRepo0,
  adapter: Ecto.Adapters.MySQL,
  username: "myuser",
  password: "mypass",
  database: "media_sample",
  hostname: "localhost",
  charset: "utf8mb4",
  pool_size: 10

config :media_sample, MediaSample.ReadRepo1,
  adapter: Ecto.Adapters.MySQL,
  username: "myuser",
  password: "mypass",
  database: "media_sample",
  hostname: "localhost",
  charset: "utf8mb4",
  pool_size: 10

config :media_sample, MediaSample.Mailer,
  server: System.get_env("MEDIA_SAMPLE_EMAIL_SERVER"),
  username: System.get_env("MEDIA_SAMPLE_EMAIL_USER"),
  passoword: System.get_env("MEDIA_SAMPLE_EMAIL_PASSWORD"),
  sender: System.get_env("MEDIA_SAMPLE_EMAIL_SENDER")

config :media_sample, MediaSample.Search,
  access_key_id: System.get_env("MEDIA_SAMPLE_ELASTICSEARCH_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("MEDIA_SAMPLE_ELASTICSEARCH_SECRET_ACCESS_KEY"),
  region: System.get_env("MEDIA_SAMPLE_ELASTICSEARCH_REGION"),
  url: System.get_env("MEDIA_SAMPLE_ELASTICSEARCH_URL")

config :arc,
  storage: Arc.Storage.Local,
  base_upload_path: "priv/static/images"

# if you want to use S3 and CloudFront, set arc config like below:
# config :arc,
#   storage: Arc.Storage.S3,
#   base_upload_path: "uploads"
#   bucket: "your_bucket_name",
#   asset_host: "https://yourservice.cloudfront.net"

config :guardian, Guardian,
  secret_key: System.get_env("MEDIA_SAMPLE_GUARDIAN_SECRET_KEY")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("MEDIA_SAMPLE_GITHUB_CLIENT_ID"),
  client_secret: System.get_env("MEDIA_SAMPLE_GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("MEDIA_SAMPLE_FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("MEDIA_SAMPLE_FACEBOOK_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("MEDIA_SAMPLE_TWITTER_CLIENT_ID"),
  consumer_secret: System.get_env("MEDIA_SAMPLE_TWITTER_CLIENT_SECRET")
