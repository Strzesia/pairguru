require "rails_helper"

describe "Movies requests", type: :request do
  let(:movie) { create(:movie) }
  let(:user) { create(:user) }

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

  describe "send_info" do
    before do
      sign_in(user)
    end

    it "sends email" do
      visit "/movies/#{movie.id}/send_info"
      expect(page).to have_selector("div", text: "Email sent with movie info")
    end
  end

  describe "export" do
    before do
      sign_in(user)
    end

    it "exports to csv" do
      expect(ExportJob).to receive(:perform_later)
      visit "/movies/export"
      expect(page).to have_selector("div", text: "Movies exported")
    end

    it "performs a job" do
      expect(ExportJob).to receive(:perform_later)
      visit "/movies/export"
    end
  end

  describe "comment" do
    before do
      sign_in(user)
    end

    context "if user hasn't commented on the movie yet" do
      it "adds comment" do
        expect do
          post comment_movie_path(movie), params: { text: "text" }
        end.to change(Comment, :count).by(1)
      end

      it "sets current user as comment author" do
        post comment_movie_path(movie), params: { text: "text" }
        expect(Comment.last).to have_attributes(user: user, text: "text")
      end
    end

    context "if user hasn't commented on the movie yet" do
      before do
        create(:comment, user: user, movie: movie)
      end

      it "adds comment" do
        expect do
          post comment_movie_path(movie), params: { text: "text" }
        end.not_to change(Comment, :count)
      end
    end
  end
end
