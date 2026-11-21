# frozen_string_literal: true

class AddSpoilerToReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :reviews, :spoiler, :boolean, null: false, default: false
  end
end
