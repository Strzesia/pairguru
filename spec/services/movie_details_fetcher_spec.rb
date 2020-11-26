require "rails_helper"

RSpec.describe MovieDetailsFetcher do
  describe ".call" do
    let!(:movie) { create(:movie) }
    let(:movie_api_attributes) do
      {
        'data': {
          'id': movie.id,
          'type': "movie",
          'attributes': {
            'title': movie.title,
            'plot': Faker::Lorem.sentence,
            'rating': 9.2,
            'poster': "/#{movie.title}.jpg"
          }
        }
      }
    end

    subject do
      MovieDetailsFetcher.new.call([movie])
    end

    before do
      body = movie_api_attributes
      title = ERB::Util.url_encode(movie.title)
      stub_fetching_movie_info(title, body)
    end

    it "should return a proper hash" do
      attributes_from_api = movie_api_attributes.deep_symbolize_keys![:data][:attributes]
      hash = {
        id: movie.id,
        title: movie.title,
        description: movie.description,
        released_at: movie.released_at,
        plot: attributes_from_api[:plot],
        rating: attributes_from_api[:rating],
        poster_url: "#{MovieDetailsFetcher::API_URL}#{attributes_from_api[:poster]}",
        genre:
              {
                id: movie.genre.id,
                name: movie.genre.name
              }
      }
      expect(subject).to eq([hash])
    end
  end
end
