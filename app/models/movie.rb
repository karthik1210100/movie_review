class Movie < ApplicationRecord
  belongs_to :user
  has_many :movie_ratings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  has_many :ratings,dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  def group_by_rating
    movie_ratings.group(:rating).count
  end

end
