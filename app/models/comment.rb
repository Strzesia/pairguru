class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates_uniqueness_of :movie_id, scope: :user, message: 'already has your comment. Delete it to comment again.'
end
