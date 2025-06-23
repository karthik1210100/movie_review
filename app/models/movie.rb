class Movie < ApplicationRecord
  belongs_to :user
  has_many :movie_ratings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :name_search, ->(query) { where("LOWER(name) LIKE ?", "%#{query.downcase}%") if query.present? }
  scope :movie_filter, ->(start_date = Date.yesterday, end_date = Date.today){where("released_at between ? and ?",start_date,end_date)}

  before_save :normalize_trailer_url

  def group_by_rating
    movie_ratings.group(:rating).count
  end

  private

  def normalize_trailer_url
    return if trailer_url.blank?

    uri = URI.parse(trailer_url)
    video_id = nil

    if uri.host&.include?("youtu.be")
      video_id = uri.path.delete_prefix("/")
    elsif uri.host&.include?("youtube.com") && uri.query.present?
      params = CGI.parse(uri.query)
      video_id = params["v"]&.first
    end

    self.trailer_url = "https://www.youtube.com/embed/#{video_id}" if video_id.present?
  end
end
