defmodule EctoStarter.Genre do
  use Ecto.Schema
  alias EctoStarter.Album

  schema "genres" do
    field(:name)
    field(:wiki_tag)
    timestamps()

    many_to_many(:albums, Album, join_through: "albums_genres")
  end
end
