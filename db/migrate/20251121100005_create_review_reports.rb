# frozen_string_literal: true

class CreateReviewReports < ActiveRecord::Migration[8.1]
  def change
    create_table :review_reports do |t|
      t.references :user,   null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true
      t.string :reason, null: false
      t.timestamps
    end
    add_index :review_reports, %i[user_id review_id], unique: true
  end
end
