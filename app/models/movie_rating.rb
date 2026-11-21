# frozen_string_literal: true

class MovieRating < ApplicationRecord
  RATING_RANGE = (1..5)

  belongs_to :movie, counter_cache: true
  belongs_to :user

  validates :rating, presence: true,
                     numericality: { only_integer: true },
                     inclusion: { in: RATING_RANGE }
  # One rating per user per movie (also enforced by a DB unique index).
  validates :user_id, uniqueness: { scope: :movie_id }
end
