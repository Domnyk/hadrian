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
  render_errors: [view: HadrianWeb.Api.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hadrian.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

api_keys_filename = "./config/api_keys.secret.exs"
if File.exists?(api_keys_filename) do
  import_config "api_keys.secret.exs"
end

config :hadrian, Hadrian.Guardian,
  issuer: "Hadrian",
  secret_key: "xDbl0IB46hIl8Biax3Tm3WBErLcKIgLRyvS/8KAxEb4u6KRnLfV/Yj3IHsFXL4gm"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
