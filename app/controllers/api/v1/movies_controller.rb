module Api
  module V1
    class MoviesController < ActionController::API
      def index
        @movies = Movie.includes(:genre)
        render :index
      end

      def show
        @movie = Movie.find_by(params[:id])
        render :show
      end
    end
  end
end
