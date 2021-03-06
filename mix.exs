defmodule Hadrian.Mixfile do
  use Mix.Project

  def project do
    [
      app: :hadrian,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Hadrian.Application, []},
      extra_applications: [:logger, :runtime_tools, :crypto, :ueberauth, :ueberauth_facebook]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_facebook, "~> 0.7"},
      {:ex_machina, "~> 2.2", only: [:dev, :test]},
      {:cors_plug, "~> 1.5"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:phoenix_integration, "~> 0.5", only: :test},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      {:plug_cowboy, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "app.launch": ["ecto.create", "ecto.migrate", "phx.server"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
