require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "validated uniqueness of movie in user scope" do
    let(:user) { create(:user) }
    let(:movie) { create(:movie) }
    let(:comment) { Comment.new(text: "text", user: user, movie: movie) }

    context "when user already commented on movie" do
      before do
        create(:comment, user: user, movie: movie)
      end

      it "does not add comment if one exists" do
        expect(comment).not_to be_valid
      end
    end

    context "when user haven't commented on movie yet" do
      it "does not add comment if one exists" do
        expect(comment).to be_valid
      end
    end
  end
end
