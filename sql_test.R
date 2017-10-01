library(DBI)
library(RSQLite)
sqlite <- dbDriver("SQLite")
art_db <- dbConnect(sqlite, "SQL/art.db")

result <- dbSendQuery(art_db, 
                      "SELECT paintings.painting_name, artists.name
                      FROM paintings INNER JOIN artists
                      ON paintings.painting_artist = artists.artist_id;")
response <- fetch(result)
head(response)
dbClearResult(result)