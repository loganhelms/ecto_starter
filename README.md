# EctoStarter

## Requirements
* Elixir: 1.16.1+
* Erlang: 26.2.2+
* Postgres: 14.10+

## Creating a table and schema

### 1. Generate a new migration to add a table 
```bash
> mix ecto.gen.migration add_artists_table
Generated ecto_starter app
* creating priv/repo/migrations/20240220021453_add_artists_table.exs
```

### 2. Modify the change function to create the table
```elixir
# ./priv/repo/migrations/20240220021453_add_artists_table.exs

defmodule EctoStarter.Repo.Migrations.AddArtistsTable do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :name, :string, null: false
      add :birth_date, :date, null: true
      add :death_date, :date, null: true
      timestamps()
    end

    create index(:artists, :name)
  end
end
```

### 3. Run the migration to create the table
```bash
> mix ecto.migrate

21:27:34.300 [info] == Running 20240220021453 EctoStarter.Repo.Migrations.AddArtistsTable.change/0 forward

21:27:34.301 [info] create table artists

21:27:34.365 [info] create index artists_name_index

21:27:34.371 [info] == Migrated 20240220021453 in 0.0s
```

### 4. Run the rollback to ensure that the migration can be reverted
```bash
> mix ecto.rollback

21:28:09.036 [info] == Running 20240220021453 EctoStarter.Repo.Migrations.AddArtistsTable.change/0 backward

21:28:09.038 [info] drop index artists_name_index

21:28:09.041 [info] drop table artists

21:28:09.056 [info] == Migrated 20240220021453 in 0.0s
```

After this step is successful rerun step 3 to add the table back. We just want to test the rollback functionality of the migration.

### 5. Add artist schema
```elixir
# ./lib/ecto_starter/artist.ex

defmodule EctoStarter.Artist do
  use Ecto.Schema

  schema "artists" do
    field(:name)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()
  end
end
```
