class Movie < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :user
  has_many :movie_ratings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :name_search, ->(query) { where("LOWER(name) LIKE ?", "%#{query.downcase}%") if query.present? }
  scope :movie_filter, ->(start_date = Date.yesterday, end_date = Date.today) { where(released_at: start_date..end_date) }

  before_validation :normalize_tags
  before_save :normalize_trailer_url

  %w[recent popular].each do |filter_type|
    scope "#{filter_type}_movies", -> {
      case filter_type
      when 'recent' then order(released_at: :desc)
      when 'popular' then order(average_rating: :desc)
      end
    }
  end

  def group_by_rating
    movie_ratings.group(:rating).count
  end

  private

  def normalize_trailer_url
    return if trailer_url.blank?

    video_id = extract_youtube_id(trailer_url)
    self.trailer_url = "https://www.youtube.com/embed/#{video_id}" if video_id.present?
  end

  def extract_youtube_id(url)
    uri = URI.parse(url)

    case uri.host
    when /youtu\.be/ then uri.path.delete_prefix("/")
    when /youtube\.com/
      CGI.parse(uri.query || '')['v']&.first if uri.query
    end
  rescue URI::InvalidURIError
    nil
  end

  def normalize_tags
    self.tag_list = case tag_list
                    when Array then tag_list.map(&:strip).reject(&:blank?)
                    when String then tag_list.split(',').map(&:strip).reject(&:blank?)
                    else tag_list
                    end
  end

  %w[highest lowest average].each do |stat|
    define_method("#{stat}_rating") do
      movie_ratings.send("#{stat}", :rating)
    end
  end
end