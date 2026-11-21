# frozen_string_literal: true

class AddDetailsToMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :movies, :description, :text
    add_column :movies, :director, :string
    add_column :movies, :runtime, :integer # minutes
  end
end
