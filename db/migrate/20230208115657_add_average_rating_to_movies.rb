class AddAverageRatingToMovies < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :average_rating, :float
  end
end
