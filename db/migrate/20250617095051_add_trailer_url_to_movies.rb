# frozen_string_literal: true

class AddTrailerUrlToMovies < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :trailer_url, :string
  end
end
