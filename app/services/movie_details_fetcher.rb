class MovieDetailsFetcher
  include HTTParty

  API_URL = 'https://pairguru-api.herokuapp.com'
  MOVIE_PATH = '/api/v1/movies/'

  def call(movies)
    movies_details = []
    movies.each do |movie|
      title = ERB::Util.url_encode(movie.title)
      response = HTTParty.get("#{API_URL}#{MOVIE_PATH}#{title}")
      movie_api_attributes = JSON.parse(response.body).deep_symbolize_keys[:data][:attributes]
      movie_details = {
          id: movie.id,
          title: movie.title,
          description: movie.description,
          released_at: movie.released_at,
          plot: movie_api_attributes[:plot],
          rating: movie_api_attributes[:rating],
          poster_url: "#{API_URL}#{movie_api_attributes[:poster]}",
          genre:
              {
                id: movie.genre.id,
                name: movie.genre.name,
              }
      }
      movies_details.push(movie_details)
    end
    movies_details
  end
end