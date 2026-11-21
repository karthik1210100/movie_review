# frozen_string_literal: true

class ReviewHelpfulVote < ApplicationRecord
  belongs_to :user
  belongs_to :review, counter_cache: false

  validates :user_id, uniqueness: { scope: :review_id }
end
