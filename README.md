# EctoStarter

## Requirements
* Elixir: 1.16.1+
* Erlang: 26.2.2+
* Postgres: 14.10+

## Connecting to a Database

### 1. Create a new project
```bash
> mix new ecto_starter --sup
```

### 2. Add Ecto dependencies
```elixir
# ./mix.exs

defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto_sql, "~> 3.11.1"}
    ]
  end
```

### 3. Create Repo module
```elixir
# ./lib/ecto_draft/repo.ex

defmodule EctoStarter.Repo do
  use Ecto.Repo,
  otp_app: :ecto_starter,
  adapter: Ecto.Adapters.Postgres
end
```

### 4. Add config
```elixir
# ./config/config.exs

config :ecto_starter, EctoStarter.Repo,
  database: "ecto_starter",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :ecto_starter, :ecto_repos, [EctoStarter.Repo]
```

### 5. Add Ecto to the supervision tree
```elixir
# ./lib/ecto_starter/application.ex

@impl true
def start(_type, _args) do
  children = [
    EctoStarter.Repo
  ]

  opts = [strategy: :one_for_one, name: EctoStarter.Supervisor]
  Supervisor.start_link(children, opts)
end
```

### 6. Fetch dependencies and compile application
```bash
> mix do deps.get, compile
Running dependency resolution...
```

### 7. Create the database
```bash
> mix ecto.create
The database for EctoStarter.Repo has been created
```