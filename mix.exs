defmodule MediaSample.Mixfile do
  use Mix.Project

  def project do
    [app: :media_sample,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {MediaSample, []},
     applications: [
      :ex_aws,
      :httpoison,
      :comeonin,
      :secure_random,
      :phoenix,
      :phoenix_pubsub,
      :phoenix_html,
      :cowboy,
      :logger,
      :gettext,
      :phoenix_ecto,
      :arc,
      :ex_enum,
      :read_repos,
      :translator,
      :ueberauth_facebook,
      :ueberauth_twitter,
      :ueberauth_github,
      :ueberauth_identity,
      :maru,
      :guardian,
      :mailman,
      :lager,
      :corman,
      :scrivener_html,
      :scrivener_headers,
      :plain_sitemap,
      :xml_builder,
      :tirexs,
      :aws_auth,
      :mariaex
      ],
     included_applications: [
      :mcd,
      :plug_session_memcached
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0-rc", override: true},
     {:phoenix_pubsub, "~> 1.0.0-rc"},
     {:phoenix_html, "~> 2.5"},
     {:mariaex, "~> 0.7"},
     {:arc, "~> 0.5"},
     {:ex_aws, "~> 0.4"},
     {:httpoison, "~> 0.8"},
     {:ecto, "~> 2.0.0-rc", override: true},
     {:phoenix_ecto, "~> 3.0.0-rc"},
     {:phoenix_live_reload, "~> 1.0", only: [:local]},
     {:gettext, "~> 0.11"},
     {:ex_enum, github: "kenta-aktsk/ex_enum"},
     # {:ex_enum, path: "/Users/kentakatsumata/Documents/workspace_elixir/ex_enum"},
     {:read_repos, github: "kenta-aktsk/read_repos"},
     # {:read_repos, path: "/Users/kentakatsumata/Documents/workspace_elixir/read_repos"},
     {:translator, github: "kenta-aktsk/translator"},
     # {:translator, path: "/Users/kentakatsumata/Documents/workspace_elixir/translator"},
     {:plain_sitemap, github: "kenta-aktsk/plain_sitemap"},
     # {:plain_sitemap, path: "/Users/kentakatsumata/Documents/workspace_elixir/plain_sitemap"},
     {:comeonin, "~> 2.4"},
     {:secure_random, "~> 0.3"},
     {:exrm, "~> 1.0" },
     {:ueberauth_facebook, "~> 0.3"},
     {:ueberauth_twitter, "~> 0.2"},
     {:ueberauth_github, "~> 0.2"},
     {:ueberauth_identity, "~> 0.2"},
     {:oauth, github: "tim/erlang-oauth"},
     {:maru, "~> 0.9"},
     {:guardian, "~> 0.11"},
     {:mailman, "~> 0.2"},
     {:eiconv, github: "zotonic/eiconv"},
     {:plug_session_memcached, github: "gutschilla/plug-session-memcached"},
     {:mcd, github: "EchoTeam/mcd"},
     {:scrivener, "~> 1.1"},
     {:scrivener_html, "~> 1.1"},
     {:scrivener_headers, "~> 1.0"},
     {:xml_builder, "~> 0.0"},
     {:tirexs, "~> 0.8"},
     # {:tirexs, github: "Zatvobor/tirexs"},
     # {:tirexs, path: "/Users/kentakatsumata/Documents/workspace_elixir/tirexs"},
     {:aws_auth, "~> 0.4"},
     # {:aws_auth, github: "bryanjos/aws_auth"},
     # {:aws_auth, path: "/Users/kentakatsumata/Documents/workspace_elixir/aws_auth"},
     {:timex, "~> 2.1", override: true},
     {:cowboy, "~> 1.0"}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
     "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
