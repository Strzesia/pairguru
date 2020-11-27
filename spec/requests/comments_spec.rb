require "rails_helper"

describe "Comments requests", type: :request do
  describe 'destroy' do
    let(:movie) { create(:movie) }
    let(:user) { create(:user) }
    let!(:comment) { create(:comment, user: user, movie: movie) }

    context 'when user is not logged in' do
      it 'does not delete comment' do
        expect do
          delete comment_path(comment)
        end.not_to change(Comment, :count)
      end
    end

    context 'when other user is logged in' do
      let(:other_user) { create(:user)}

      before do
        sign_in(other_user)
      end

      it 'does not delete comment' do
        expect do
          delete comment_path(comment)
        end.not_to change(Comment, :count)
      end
    end

    context 'when logged user deletes their comment' do
      before do
        sign_in(user)
      end

      it 'deletes comment' do
        expect do
          delete comment_path(comment)
        end.to change(Comment, :count).by(-1)
      end
    end
  end
end
