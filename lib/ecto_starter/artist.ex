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
