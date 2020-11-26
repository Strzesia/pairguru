class GenresController < ApplicationController
  def index
    @genres = Genre.all.decorate
  end

  def movies
    @genre = Genre.find(params[:id]).decorate
    @movies = MovieDetailsFetcher.new.call(@genre.movies)
  end
end
