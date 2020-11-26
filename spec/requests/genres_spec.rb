require "rails_helper"

describe "Genres requests", type: :request do
  let!(:genres) { create_list(:genre, 5, :with_movies) }

  describe "genre movies list" do
    before do
      genres.each do |genre|
        genre.movies.each do |movie|
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
    end

    it "displays only related movies" do
      genre_id = genres.sample.id.to_s
      visit "/genres/#{genre_id}/movies"
      expect(page).to have_selector("table tbody tr", count: 5)
    end
  end

  describe "genres list" do
    it "displays all genres" do
      visit "/genres"
      expect(page).to have_selector("table tbody tr", count: 5)
    end
  end
end
