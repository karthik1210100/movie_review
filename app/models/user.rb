class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :movies
  has_many :user_review_comments
  has_many :reviews, through: :user_review_comments
  has_one_attached :avatar,dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
