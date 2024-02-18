import Config

config :ecto_starter, EctoStarter.Repo,
  database: "ecto_starter",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :ecto_starter, :ecto_repos, [EctoStarter.Repo]
