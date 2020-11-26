class GenreDecorator < Draper::Decorator
  delegate_all

  def number_of_movies
    object.movies.count
  end
end
