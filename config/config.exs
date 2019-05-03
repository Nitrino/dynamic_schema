# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dynamic_schema,
  ecto_repos: [DynamicSchema.Repo]

# Configures the endpoint
config :dynamic_schema, DynamicSchemaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W3Joy/WFj5SqLLieNndHZNCwdunYRHZ0Z/9+nJ/6NzReLSW+GUCqL1nFkVJQkpL3",
  render_errors: [view: DynamicSchemaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DynamicSchema.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ImiS5UKs"]

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
