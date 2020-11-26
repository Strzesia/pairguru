require "rails_helper"

describe "Movies requests", type: :request do
  describe "movies list" do
    let!(:movies) { create_list(:movie, 3) }
    before do
      movies.each do |movie|
        body = {
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
        title = ERB::Util.url_encode(movie.title)
        stub_fetching_movie_info(title, body)
      end
    end

    it "displays right title" do
      visit "/movies"
      expect(page).to have_selector("h1", text: "Movies")
    end

    it "displays all movies" do
      visit "/movies"
      expect(page).to have_selector("table tbody tr", count: 3)
    end
  end

  describe "movie" do
    let(:movie) { create(:movie) }
    before do
      body = {
        'data': {
          'id': movie.id,
          'type': "movie",
          'attributes': {
            'title': movie.title,
            'plot': Faker::Lorem.sentence,
            'rating': 9.2,
            'poster': "/#{title}.jpg"
          }
        }
      }
      title = ERB::Util.url_encode(movie.title)
      stub_fetching_movie_info(title, body)
    end

    it "displays right title" do
      visit "/movies/#{movie.id}"
      expect(page).to have_selector("h1", text: movie.title)
    end

    it "displays poster" do
      visit "/movies/#{movie.id}"
      expect(page).to have_selector("img")
    end
  end
end
