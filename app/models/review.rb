# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  has_many :user_review_comments, dependent: :destroy
  has_many :commenters, through: :user_review_comments, source: :user

  validates :about, presence: true
end
