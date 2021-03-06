use Mix.Config

host = "thawing-crag-67620.herokuapp.com"
client_url = "https://vinci-11235813.herokuapp.com"

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# HadrianWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :hadrian, HadrianWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: host, port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger,
       level: :info,
       format: "$time $metadata[$level] $message\n",
       metadata: [:module, :function, :user_id]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :hadrian, HadrianWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [:inet6,
#               port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :hadrian, HadrianWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :hadrian, HadrianWeb.Endpoint, server: true
#

config :hadrian, Hadrian.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

# Configure access token module for Facebook
config :hadrian, :fb_access_token, Hadrian.Authentication.Facebook

# Configure client url
config :hadrian, :client_url, client_url

config :hadrian, :domain, "vinci-11235813.herokuapp.com"

# Redirect url when client's session in created
config :hadrian, :redirect_client_url, client_url <> "/login_ok"

# Paypal
config :hadrian, :api_url, "https://api.sandbox.paypal.com"
config :hadrian, :paypal_storage, Hadrian.PaypalStorage
