class CommentsController < ApplicationController
  def destroy
    comment = Comment.find_by(params[:id])
    movie = comment.movie
    if comment.destroy
      redirect_to movie, notice: 'Comment deleted'
    else
      redirect_to movie, flash: { danger: comment.errors.full_messages.join('. ') }
    end
  end
end
