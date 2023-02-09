class AddReviewCommentToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :review_comment, :string
  end
end
