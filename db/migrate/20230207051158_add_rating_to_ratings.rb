# frozen_string_literal: true

class AddRatingToRatings < ActiveRecord::Migration[7.0]
  def change
    add_column :ratings, :rating, :integer
  end
end
