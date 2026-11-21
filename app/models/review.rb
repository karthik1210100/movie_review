# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  has_many :user_review_comments, dependent: :destroy
  has_many :commenters, through: :user_review_comments, source: :user
  has_many :review_helpful_votes, dependent: :destroy
  has_many :helpful_voters, through: :review_helpful_votes, source: :user
  has_many :review_reports, dependent: :destroy

  validates :about, presence: true

  def helpful_count
    review_helpful_votes.size
  end

  def marked_helpful_by?(user)
    return false if user.blank?

    review_helpful_votes.exists?(user_id: user.id)
  end
end
