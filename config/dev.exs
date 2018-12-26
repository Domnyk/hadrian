use Mix.Config

host = "localhost"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :hadrian, HadrianWeb.Endpoint,
  http: [port: 4001],
  https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.crt"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :hadrian, HadrianWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/gettext/.*(po)$},
      ~r{lib/hadrian_web/views/.*(ex)$},
    ]
  ]

config :logger, :console,
       format: "$metadata[$level] $message\n",
       metadata: [:module, :function, :user_id]

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Include api keys. Will work only on dev machine
api_keys_file_name = "api_keys.secret.exs"
if File.exists?(api_keys_file_name) do
  import_config api_keys_file_name
end

# Configure your database
config :hadrian, Hadrian.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "dev",
  hostname: System.get_env("POSTGRES_HOST") || host,
  pool_size: 10

# Configure access token module for Facebook
config :hadrian, :access_token, Hadrian.Session.Facebook.AccessToken.HTTP

# Configure client url
config :hadrian, :client_url, "https://localhost:8080"

# Configure Paypal
config :hadrian, :api_url, "https://api.sandbox.paypal.com"
config :hadrian, :paypal_storage, Hadrian.PaypalStorage

