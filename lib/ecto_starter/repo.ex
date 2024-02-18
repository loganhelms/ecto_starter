defmodule EctoStarter.Repo do
  use Ecto.Repo,
  otp_app: :ecto_starter,
  adapter: Ecto.Adapters.Postgres
end
