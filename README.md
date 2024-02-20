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

### 5. Add album schema
```elixir
# ./lib/ecto_starter/album.ex

defmodule EctoStarter.Album do
  use Ecto.Schema
  alias EctoStarter.Artist

  schema "albums" do
    field(:title, :string)
    timestamps()

    belongs_to(:artist, Artist)
  end
end
```

### 6. Update ./lib/ecto_starter/artist.ex
```elixir
defmodule EctoStarter.Artist do
  use Ecto.Schema
  alias EctoStarter.Album

  schema "artists" do
    field(:name)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()

    has_many(:albums, Album)
  end
end
```


### 7. Update ./priv/repo/seeds.exs
```elixir
alias EctoStarter.{Repo, Artist, Album}

Repo.insert! %Artist{
  name: "Miles Davis",
  albums: [
    %Album{title: "Kind Of Blue"},
    %Album{title: "Cookin' At The Plugged Nickel"}
  ]}

Repo.insert! %Artist{
  name: "Bill Evans",
  albums: [
    %Album{title: "You Must Believe In Spring"},
    %Album{title: "Portrait In Jazz"}
  ]}

Repo.insert! %Artist{
  name: "Bobby Hutcherson",
  albums: [
    %Album{title: "Live At Montreaux"}
  ]}


IO.puts ""
IO.puts "Success! Sample data has been added."
```

### 8. Update mix.exs to add aliases to ease ecto usage
```elixir
# ./mix.exs
...

def project do
  [
    ...,
    aliases: aliases()
  ]
end

...

defp aliases do
  [
    "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
    "ecto.reset": ["ecto.drop", "ecto.setup"]
  ]
end
...
```

### 9. Run mix ecto.reset to reset the database and load the new seed data
```bash
mix ecto.reset
Compiling 1 file (.ex)
The database for EctoStarter.Repo has been dropped
The database for EctoStarter.Repo has been created

00:13:00.827 [info] == Running 20240220021453 EctoStarter.Repo.Migrations.AddArtistsTable.change/0 forward

00:13:00.829 [info] create table artists

00:13:00.874 [info] create index artists_name_index

00:13:00.877 [info] == Migrated 20240220021453 in 0.0s

00:13:00.941 [info] == Running 20240220043106 EctoStarter.Repo.Migrations.AddAlbumsTable.change/0 forward

00:13:00.941 [info] create table albums

00:13:00.946 [info] create index albums_artist_id_index

00:13:00.949 [info] == Migrated 20240220043106 in 0.0s

00:13:00.994 [debug] QUERY OK db=0.4ms idle=11.9ms
begin []

00:13:01.007 [debug] QUERY OK source="artists" db=1.0ms
INSERT INTO "artists" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Miles Davis", ~N[2024-02-20 05:13:00], ~N[2024-02-20 05:13:00]]

00:13:01.060 [debug] QUERY OK source="albums" db=50.6ms
INSERT INTO "albums" ("title","artist_id","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Kind Of Blue", 1, ~N[2024-02-20 05:13:01], ~N[2024-02-20 05:13:01]]

00:13:01.061 [debug] QUERY OK source="albums" db=1.0ms
INSERT INTO "albums" ("title","artist_id","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Cookin' At The Plugged Nickel", 1, ~N[2024-02-20 05:13:01], ~N[2024-02-20 05:13:01]]

00:13:01.103 [debug] QUERY OK db=42.0ms
commit []

00:13:01.104 [debug] QUERY OK db=0.7ms idle=123.9ms
begin []

00:13:01.106 [debug] QUERY OK source="artists" db=0.6ms
INSERT INTO "artists" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Bill Evans", ~N[2024-02-20 05:13:01], ~N[2024-02-20 05:13:01]]

00:13:01.108 [debug] QUERY OK source="albums" db=1.0ms
INSERT INTO "albums" ("title","artist_id","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["You Must Believe In Spring", 2, ~N[2024-02-20 05:13:01], ~N[2024-02-20 05:13:01]]

00:13:01.108 [debug] QUERY OK source="albums" db=0.4ms
INSERT INTO "albums" ("title","artist_id","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Portrait In Jazz", 2, ~N[2024-02-20 05:13:01], ~N[2024-02-20 05:13:01]]

00:13:01.111 [debug] QUERY OK db=2.5ms
commit []

00:13:01.112 [debug] QUERY OK db=0.6ms idle=131.6ms
begin []

00:13:01.119 [debug] QUERY OK source="artists" db=1.0ms
INSERT INTO "artists" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Bobby Hutcherson", ~N[2024-02-20 05:13:01], ~N[2024-02-20 05:13:01]]

00:13:01.121 [debug] QUERY OK source="albums" db=1.1ms
INSERT INTO "albums" ("title","artist_id","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Live At Montreaux", 3, ~N[2024-02-20 05:13:01], ~N[2024-02-20 05:13:01]]


00:13:01.122 [debug] QUERY OK db=0.5ms
commit []
Success! Sample data has been added.
```