# frozen_string_literal: true

class CreateReviewHelpfulVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :review_helpful_votes do |t|
      t.references :user,   null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true
      t.timestamps
    end
    add_index :review_helpful_votes, %i[user_id review_id], unique: true
  end
end
