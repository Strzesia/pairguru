class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    movies = Movie.all
    @movies = MovieDetailsFetcher.new.call(movies)
  end

  def show
    movie = Movie.find(params[:id])
    @movie = MovieDetailsFetcher.new.call([movie]).first
    @comments = movie.comments
  end

  def comment
    movie = Movie.find(params[:id])
    comment = Comment.new(text: params[:text], user: current_user, movie: movie)
    if comment.save
      redirect_to movie, notice: 'Comment added'
    else
      redirect_to movie, flash: { danger: comment.errors.full_messages.join('. ') }
    end
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_later
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    ExportJob.perform_later(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end
end
