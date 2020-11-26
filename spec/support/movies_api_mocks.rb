module MoviesApiMocks
  def stub_fetching_movie_info(movie, body)
    stub_request(:get, "https://pairguru-api.herokuapp.com/api/v1/movies/#{movie}")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body: body.to_json, headers: {})
  end
end
