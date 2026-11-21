# frozen_string_literal: true

class ReviewReport < ApplicationRecord
  REASONS = ['Spam or advertising', 'Offensive or abusive', 'Spoiler not tagged', 'Other'].freeze

  belongs_to :user
  belongs_to :review

  validates :reason, presence: true, inclusion: { in: REASONS }
  validates :user_id, uniqueness: { scope: :review_id,
                                    message: 'has already reported this review' }
end
