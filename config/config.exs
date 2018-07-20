# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hadrian,
  ecto_repos: [Hadrian.Repo]

# Configures the endpoint
config :hadrian, HadrianWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "L0RSyHq4k0huwHEmCZnZWj011NNkWpyi995n7zdRCRYdxCb0yljAUR9j9v+apNXo",
  render_errors: [view: HadrianWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hadrian.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

api_keys_filename = "api_keys.secret.exs"
if File.exists?("api_keys") do
  import_config api_keys_filename
end

# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [] }
  ]

# Configures Ueberauth facebook strategy
config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
	client_id: System.get_env("FACEBOOK_APP_ID"),
	client_secret: System.get_env("FACEBOOK_APP_SECRET"),
	redirect_uri: System.get_env("FACEBOOK_REDIRECT_URI")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
