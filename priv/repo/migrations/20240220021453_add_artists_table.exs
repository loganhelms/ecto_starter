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
