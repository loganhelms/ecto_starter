alias EctoStarter.{Repo, Artist, Album, Genre}

jazz_genre = Repo.insert!(%Genre{ name: "jazz", wiki_tag: "Jazz" })
live_genre = Repo.insert!(%Genre{ name: "live", wiki_tag: "Concert" })

Repo.insert! %Artist{
  name: "Miles Davis",
  albums: [
    %Album{
      title: "Kind Of Blue",
      genres: [jazz_genre]
    },
    %Album{
      title: "Cookin' At The Plugged Nickel",
      genres: [jazz_genre, live_genre]
    }
  ]}

Repo.insert! %Artist{
  name: "Bill Evans",
  albums: [
    %Album{
      title: "You Must Believe In Spring",
      genres: [jazz_genre]
    },
    %Album{
      title: "Portrait In Jazz",
      genres: [jazz_genre]
    }
  ]}

Repo.insert! %Artist{
  name: "Bobby Hutcherson",
  albums: [
    %Album{title: "Live At Montreaux"}
  ]}


IO.puts ""
IO.puts "Success! Sample data has been added."
