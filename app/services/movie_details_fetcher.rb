class MovieDetailsFetcher
  include HTTParty

  API_URL = "https://pairguru-api.herokuapp.com".freeze
  MOVIE_PATH = "/api/v1/movies/".freeze

  def call(movies)
    movies_details = []
    movies.each do |movie|
      movies_details.push(fetch_details_from_api(movie))
    end
    movies_details
  end

  private

  def fetch_details_from_api(movie)
    title = ERB::Util.url_encode(movie.title)
    response = HTTParty.get("#{API_URL}#{MOVIE_PATH}#{title}")
    movie_api_attributes = JSON.parse(response.body).deep_symbolize_keys[:data][:attributes]
    movie_details_hash(movie, movie_api_attributes)
  end

  def movie_details_hash(movie, movie_api_attributes)
    {
      id: movie.id,
      title: movie.title,
      description: movie.description,
      released_at: movie.released_at,
      plot: movie_api_attributes[:plot],
      rating: movie_api_attributes[:rating],
      poster_url: "#{API_URL}#{movie_api_attributes[:poster]}",
      genre: genre_details_hash(movie)
    }
  end

  def genre_details_hash(movie)
    {
      id: movie.genre.id,
      name: movie.genre.name
    }
  end
end
