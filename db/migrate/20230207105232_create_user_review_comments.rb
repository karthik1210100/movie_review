class CreateUserReviewComments < ActiveRecord::Migration[7.0]
  def change
    create_table :user_review_comments do |t|
      t.string :comment
      t.integer :review_id
      t.integer :user_id

      t.timestamps
    end
  end
end
