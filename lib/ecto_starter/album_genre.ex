defmodule EctoStarter.AlbumGenre do
  use Ecto.Schema
  alias EctoStarter.{Album, Genre}

  schema "albums_genres" do
    belongs_to(:albums, Album)
    belongs_to(:genres, Genre)
  end
end
