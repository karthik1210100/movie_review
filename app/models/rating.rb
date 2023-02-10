class Rating < ApplicationRecord
  # belongs_to :movie
  # after_commit do
  #   avg_rating = Movie.find((self.movie_id)).ratings.average(:rating)
  #   Movie.find((self.movie_id)).update_columns(average_rating: avg_rating)
  # end
end
