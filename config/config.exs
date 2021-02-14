# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :web_authn,
  ecto_repos: [WebAuthn.Repo]

# Configures the endpoint
config :web_authn, WebAuthnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EL8XJ1WlZFDsf+OnAXlFYG/UMM6aGT1KjPEVYubToeAeZSUG2UASkFWZql1JVFj/",
  render_errors: [view: WebAuthnWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: WebAuthn.PubSub,
  live_view: [signing_salt: "2bP74ltV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
