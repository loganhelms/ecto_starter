# EctoStarter

## Requirements
* Elixir: 1.16.1+
* Erlang: 26.2.2+
* Postgres: 14.10+

## One-to-many relational tables and schemas

### 1. Generate a new migration to add the albums table 
```bash
> mix ecto.gen.migration add_albums_table
* creating priv/repo/migrations/20240220043106_add_albums_table.exs
```

### 2. Modify the change function to create the album table
```elixir
# ./priv/repo/migrations/20240220043106_add_albums_table.exs

defmodule EctoStarter.Repo.Migrations.AddAlbumsTable do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :title, :string, null: false
      add :artist_id, references(:artists, on_delete: :nothing)
      timestamps()
    end

    create index(:albums, :artist_id)
  end
end

```

### 3. Run the migration to create the table
```bash
> mix ecto.migrate

23:35:41.914 [info] == Running 20240220043106 EctoStarter.Repo.Migrations.AddAlbumsTable.change/0 forward

23:35:41.916 [info] create table albums

23:35:41.981 [info] create index albums_artist_id_index

23:35:41.984 [info] == Migrated 20240220043106 in 0.0s
```

### 4. Run the rollback to ensure that the migration can be reverted
```bash
> mix ecto.rollback

23:36:26.837 [info] == Running 20240220043106 EctoStarter.Repo.Migrations.AddAlbumsTable.change/0 backward

23:36:26.838 [info] drop index albums_artist_id_index

23:36:26.840 [info] drop table albums

23:36:26.851 [info] == Migrated 20240220043106 in 0.0s
```

After this step is successful rerun step 3 to add the table back. We just want to test the rollback functionality of the migration.
