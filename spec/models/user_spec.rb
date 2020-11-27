require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to allow_value("+48 999 888 777").for(:phone_number) }
  it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
  it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
  it { is_expected.not_to allow_value("+48 aaa bbb ccc").for(:phone_number) }
  it { is_expected.not_to allow_value("aaa +48 aaa bbb ccc").for(:phone_number) }
  it { is_expected.not_to allow_value("+48 999 888 777\naseasd").for(:phone_number) }

  describe "scopes" do
    let!(:user) { create(:user) }
    let!(:comment) do
      create(:comment,
             created_at: Time.current - 1.hour,
             user: user,
             movie: create(:movie))
    end
    let!(:second_comment) do
      create(:comment,
             created_at: Time.current - 8.days,
             user: user,
             movie: create(:movie))
    end
    let!(:another_user) { create(:user) }

    context "with_recent_comments" do
      it "displays correct users" do
        expect(User.with_recent_comments).to include(user)
        expect(User.with_recent_comments).not_to include(another_user)
      end

      it "displays correct comments" do
        expect(User.with_recent_comments.first.comments).to include(comment)
        expect(User.with_recent_comments.first.comments).not_to include(second_comment)
      end
    end
  end

  describe "recent_comments_count" do
    let(:user) { create(:user) }
    let!(:recent_comment) do
      create(:comment,
             user: user,
             movie: create(:movie))
    end
    let!(:old_comment) do
      create(:comment,
             user: user,
             movie: create(:movie),
             created_at: Time.current - 8.days)
    end

    it "displays correct number" do
      expect(user.recent_comments_count).to eq(1)
    end
  end
end
