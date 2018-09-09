use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hadrian, HadrianWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :hadrian, Hadrian.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "hadrian_test_created_with_migration",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Required by PhoenixIntegration
config :phoenix_integration,
  endpoint: HadrianWeb.Endpoint

# Configure access token module for Facebook
config :hadrian, :access_token, Hadrian.Session.Facebook.AccessToken.InMemory