class MovieRating < ApplicationRecord
  belongs_to :movie, counter_cache: true
  belongs_to :user

  # Constants
  RATINGS = { '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5 }.freeze
end
