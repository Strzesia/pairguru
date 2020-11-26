require "rails_helper"

describe "Api movies requests", type: :request do
  describe "movies list" do
    let!(:genres) { create_list(:genre, 3, :with_movies) }

    it 'displays all movies' do
      get api_v1_movies_path
      expect(json_response[:movies].size).to eq(15)
    end

    it 'displays proper movie attributes' do
      get api_v1_movies_path
      expect(json_response[:movies].first).to include(:id, :title, genre: hash_including(:id, :name, :number_of_movies))
    end
  end

  describe 'movie' do
    let!(:movie) { create(:movie) }

    it 'displays proper movie attributes' do
      get api_v1_movie_path(movie)
      expect(json_response).to include(:id, :title, genre: hash_including(:id, :name, :number_of_movies))
    end
  end
end

def json_response
  JSON.parse(response.body).deep_symbolize_keys
end