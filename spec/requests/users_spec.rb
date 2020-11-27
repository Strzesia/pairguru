require "rails_helper"

describe "Users requests", type: :request do
  describe 'top commenters' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment, created_at: Time.current - 1.hour, user: user, movie: create(:movie)) }
    let!(:second_comment) { create(:comment, created_at: Time.current - 8.days, user: user, movie: create(:movie)) }
    let!(:another_user) { create(:user) }

    it 'displays proper users' do
      visit '/users/top_commenters'
      expect(page).to have_selector("table tbody tr", count: 1)
    end
  end
end
