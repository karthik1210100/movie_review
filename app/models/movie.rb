class Movie < ApplicationRecord
  belongs_to :user
  has_many :ratings
  has_many :reviews
  validates :name, presence: true, uniqueness: true
end
