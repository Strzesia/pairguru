class UsersController < ApplicationController
  def top_commenters
    @users = User.with_recent_comments
  end
end
