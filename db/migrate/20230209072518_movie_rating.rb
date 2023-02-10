class MovieRating < ActiveRecord::Migration[7.0]
  def change
    create_table :movie_ratings do |t|
      t.integer :movie_id
      t.integer :rating
      t.integer :user_id

      t.timestamps
    end
  end
end
