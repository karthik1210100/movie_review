# frozen_string_literal: true

class UserReviewComment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :comment, presence: true
end
