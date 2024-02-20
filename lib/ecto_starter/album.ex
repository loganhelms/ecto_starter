defmodule EctoStarter.Album do
  use Ecto.Schema
  alias EctoStarter.Artist

  schema "albums" do
    field(:title, :string)
    timestamps()

    belongs_to(:artist, Artist)
  end
end
