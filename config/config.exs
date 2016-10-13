# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rali_guardian,
  ecto_repos: [RaliGuardian.Repo]

# Configures the endpoint
config :rali_guardian, RaliGuardian.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Mw2gbyBjAGBUVClIYN8EXpDtGhoF7vVaQFafLaY+YF3foKN24GURXvTMs1Qg8SOO",
  render_errors: [view: RaliGuardian.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RaliGuardian.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "RaliGuardian.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: RaliGuardian.GuardianSerializer,
  secret_key: to_string(Mix.env),
  hooks: GuardianDb,
  permissions: %{
    default: [
      :read_profile,
      :write_profile,
      :read_token,
      :revoke_token,
    ],
  }

config :guardian_db, GuardianDb,
  repo: RaliGuardian.Repo,
  sweep_interval: 60 # 60 minutes

config :ueberauth, Ueberauth,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
  ]


# config :guardian_db, GuardianDb,
#   repo: PhoenixGuardian.Repo,
#   sweep_interval: 60 # 60 minutes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
