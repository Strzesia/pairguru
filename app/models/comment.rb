class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :movie_id,
            uniqueness: { scope: :user,
                          message: "already has your comment. Delete it to comment again." }

  scope :sorted, -> { group(:user_id) }
end
