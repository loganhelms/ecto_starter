defmodule EctoStarter.Album do
  use Ecto.Schema
  alias EctoStarter.{Artist, Genre}

  schema "albums" do
    field(:title, :string)
    timestamps()

    belongs_to(:artist, Artist)
    many_to_many(:genres, Genre, join_through: "albums_genres")
  end
end
