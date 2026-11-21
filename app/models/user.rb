# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar, dependent: :purge_later

  # Content authored by the user is removed with the account (no orphan rows).
  has_many :movies, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :movie_ratings, dependent: :destroy
  has_many :user_review_comments, dependent: :destroy
  # Reviews this user has commented on (distinct from authored reviews above).
  has_many :commented_reviews, through: :user_review_comments, source: :review

  has_many :watchlist_items, dependent: :destroy
  has_many :watchlisted_movies, through: :watchlist_items, source: :movie
  has_many :review_helpful_votes, dependent: :destroy
  has_many :review_reports, dependent: :destroy

  # Email presence/format/uniqueness and password length are provided by
  # Devise's :validatable module (see config/initializers/devise.rb).

  # Public display name for profiles (never exposes the email).
  def display_name
    [first_name, last_name].compact_blank.join(' ').presence || 'Movie fan'
  end
end
