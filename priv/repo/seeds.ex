alias EctoStarter.{Repo, Artist}

Repo.insert! %Artist{name: "Miles Davis"}
Repo.insert! %Artist{name: "Bill Evans"}
Repo.insert! %Artist{name: "Bobby Hutcherson"}

IO.puts ""
IO.puts "Success! Sample data has been added."
