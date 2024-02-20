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

### 6. Add an .iex.exs file to make testing with IEx easier

```elixir
# ./.iex.exs

alias EctoStarter.{Repo, Artist}

import_if_available Ecto.Query
```

### 7. Start an IEx session

```bash
> iex -S mix
Erlang/OTP 26 [erts-14.2.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1]

Interactive Elixir (1.16.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> 
```

### 8. Querying count with SQL
```elixir
iex(1)> Repo.query("select count(1) from artists;")

22:13:07.610 [debug] QUERY OK db=2.7ms decode=1.0ms queue=6.8ms idle=327.3ms
select count(id) from artists; []
{:ok,
 %Postgrex.Result{
   command: :select,
   columns: ["count"],
   rows: [[0]],
   num_rows: 1,
   connection_id: 58619,
   messages: []
 }}
```

### 9. Querying count via Repo.aggregation/3
```elixir
iex(2)> Repo.aggregate("artists", :count, :id)

22:18:48.407 [debug] QUERY OK source="artists" db=0.6ms queue=1.7ms idle=1084.1ms
SELECT count(a0."id") FROM "artists" AS a0 []
0
```

### 10. Seed the database and retest 7-9
```bash
> mix run priv/repo/seeds.ex 

22:27:11.289 [debug] QUERY OK source="artists" db=47.1ms decode=1.4ms queue=55.9ms idle=0.0ms
INSERT INTO "artists" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Miles Davis", ~N[2024-02-20 03:27:11], ~N[2024-02-20 03:27:11]]

22:27:11.333 [debug] QUERY OK source="artists" db=41.5ms queue=1.1ms idle=99.7ms
INSERT INTO "artists" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Bill Evans", ~N[2024-02-20 03:27:11], ~N[2024-02-20 03:27:11]]


22:27:11.342 [debug] QUERY OK source="artists" db=6.6ms queue=1.8ms idle=142.7ms
INSERT INTO "artists" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Bobby Hutcherson", ~N[2024-02-20 03:27:11], ~N[2024-02-20 03:27:11]]
Success! Sample data has been added.
```

Create a new IEx session and retest step 8:
```bash
> iex -S mix
Erlang/OTP 26 [erts-14.2.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1]

Interactive Elixir (1.16.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Repo.query("select count(1) from artists;")

22:30:10.563 [debug] QUERY OK db=1.2ms decode=1.3ms queue=3.9ms idle=125.5ms
select count(1) from artists; []
{:ok,
 %Postgrex.Result{
   command: :select,
   columns: ["count"],
   rows: [[3]],
   num_rows: 1,
   connection_id: 59909,
   messages: []
 }}
```

Retest step 9:
```elixir
iex(2)> Repo.aggregate("artists", :count, :id)

22:32:24.638 [debug] QUERY OK source="artists" db=1.4ms queue=1.2ms idle=171.8ms
SELECT count(a0."id") FROM "artists" AS a0 []
3
```

### 11. Test all repository pattern operations
```elixir
iex(3)> Repo.insert(%Artist{name: "Dizzy Gillespie"})

22:50:55.371 [debug] QUERY OK source="artists" db=42.5ms queue=1.0ms idle=807.5ms
INSERT INTO "artists" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Dizzy Gillespie", ~N[2024-02-20 03:50:55], ~N[2024-02-20 03:50:55]]
{:ok,
 %EctoStarter.Artist{
   __meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
   id: 4,
   name: "Dizzy Gillespie",
   birth_date: nil,
   death_date: nil,
   inserted_at: ~N[2024-02-20 03:50:55],
   updated_at: ~N[2024-02-20 03:50:55]
 }}
iex(4)> dizzy = Repo.get_by(Artist, name: "Dizzy Gillespie")

22:51:29.267 [debug] QUERY OK source="artists" db=1.5ms queue=48.4ms idle=700.2ms
SELECT a0."id", a0."name", a0."birth_date", a0."death_date", a0."inserted_at", a0."updated_at" FROM "artists" AS a0 WHERE (a0."name" = $1) ["Dizzy Gillespie"]
%EctoStarter.Artist{
  __meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
  id: 4,
  name: "Dizzy Gillespie",
  birth_date: nil,
  death_date: nil,
  inserted_at: ~N[2024-02-20 03:50:55],
  updated_at: ~N[2024-02-20 03:50:55]
}
iex(5)> Repo.update(Ecto.Changeset.change(dizzy, name: "John Birks Gillespie"))

22:52:08.624 [debug] QUERY OK source="artists" db=2.8ms queue=8.2ms idle=96.8ms
UPDATE "artists" SET "name" = $1, "updated_at" = $2 WHERE "id" = $3 ["John Birks Gillespie", ~N[2024-02-20 03:52:08], 4]
{:ok,
 %EctoStarter.Artist{
   __meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
   id: 4,
   name: "John Birks Gillespie",
   birth_date: nil,
   death_date: nil,
   inserted_at: ~N[2024-02-20 03:50:55],
   updated_at: ~N[2024-02-20 03:52:08]
 }}
iex(6)> dizzy = Repo.get_by(Artist, name: "John Birks Gillespie")

22:52:31.780 [debug] QUERY OK source="artists" db=4.9ms queue=0.2ms idle=1257.5ms
SELECT a0."id", a0."name", a0."birth_date", a0."death_date", a0."inserted_at", a0."updated_at" FROM "artists" AS a0 WHERE (a0."name" = $1) ["John Birks Gillespie"]
%EctoStarter.Artist{
  __meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
  id: 4,
  name: "John Birks Gillespie",
  birth_date: nil,
  death_date: nil,
  inserted_at: ~N[2024-02-20 03:50:55],
  updated_at: ~N[2024-02-20 03:52:08]
}
iex(7)> Repo.delete(dizzy)

22:52:42.741 [debug] QUERY OK source="artists" db=6.3ms queue=0.8ms idle=1217.6ms
DELETE FROM "artists" WHERE "id" = $1 [4]
{:ok,
 %EctoStarter.Artist{
   __meta__: #Ecto.Schema.Metadata<:deleted, "artists">,
   id: 4,
   name: "John Birks Gillespie",
   birth_date: nil,
   death_date: nil,
   inserted_at: ~N[2024-02-20 03:50:55],
   updated_at: ~N[2024-02-20 03:52:08]
 }}
```