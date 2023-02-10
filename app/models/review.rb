class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user
  has_many :user_review_comments
  has_many :users, through: :user_review_comments
end
