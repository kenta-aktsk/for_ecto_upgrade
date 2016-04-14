defmodule MediaSample.Endpoint do
  use Phoenix.Endpoint, otp_app: :media_sample

  socket "/socket", MediaSample.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :media_sample, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    key: "_media_sample_key",
    store: :memcached,
    signing_salt: "Hco0rRT0",
    table: :memcached_sessions,
    encryption_salt: "C5sWyZPx"

  plug MediaSample.Router

  def config, do: Application.get_env(:media_sample, __MODULE__)
end
