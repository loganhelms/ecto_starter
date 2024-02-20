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
