defmodule ForEctoUpgrade.Mixfile do
  use Mix.Project

  def project do
    [app: :for_ecto_upgrade,
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
    [mod: {ForEctoUpgrade, []},
     applications: [
      :ex_aws,
      :httpoison,
      :comeonin,
      :secure_random,
      :phoenix, 
      :phoenix_html, 
      :cowboy, 
      :logger, 
      :gettext,
      :phoenix_ecto, 
      :arc,
      :ex_enum,
      :read_repos,
      # :postgrex
      :ueberauth_facebook,
      :ueberauth_twitter,
      :ueberauth_github,
      :ueberauth_identity,
      :maru,
      :guardian,
      :mariaex
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
    [{:phoenix, "~> 1.1.4"},
     # {:postgrex, ">= 0.0.0"},
     {:mariaex, ">= 0.0.0"},
     # {:phoenix_ecto, "~> 2.0"},
     {:arc, "~> 0.5.1"},
     {:ex_aws, "~> 0.4.10"},
     {:httpoison, "~> 0.7"},
     {:ecto, "~> 2.0.0-beta", github: "elixir-lang/ecto", override: true},
     {:phoenix_ecto, "~> 3.0.0-beta"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: [:local, :dev]},
     {:gettext, "~> 0.9"},
     {:ex_enum, github: "kenta-aktsk/ex_enum"},
     # {:ex_enum, path: "/Users/kentakatsumata/Documents/workspace_elixir/ex_enum"},
     {:read_repos, github: "kenta-aktsk/read_repos"},
     # {:read_repos, path: "/Users/kentakatsumata/Documents/workspace_elixir/read_repos"},
     {:comeonin, "~> 1.6"},
     {:secure_random, "~> 0.2"},
     {:exrm, "~> 1.0" },
     {:ueberauth_facebook, "~> 0.3"},
     {:ueberauth_twitter, "~> 0.2"},
     {:ueberauth_github, "~> 0.2"},
     {:ueberauth_identity, "~> 0.2"},
     {:oauth, github: "tim/erlang-oauth"},
     {:maru, "~> 0.8"},
     {:guardian, "~> 0.10.0"},
     {:cowboy, "~> 1.0"}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
