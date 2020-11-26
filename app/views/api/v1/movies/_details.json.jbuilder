json.id movie.id
json.title movie.title
json.genre do
  json.id movie.genre.id
  json.name movie.genre.name
  json.number_of_movies movie.genre.movies.count
end