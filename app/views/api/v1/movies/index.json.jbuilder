json.movies do
  @movies.each do |movie|
    json.child! do
      json.partial! "api/v1/movies/details", movie: movie
    end
  end
end
