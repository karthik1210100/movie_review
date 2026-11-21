# frozen_string_literal: true

class Movie < ApplicationRecord
  acts_as_taggable_on :tags

  # Only a canonical YouTube embed URL is ever accepted/stored, so the value
  # rendered inside the trailer <iframe> can never be an attacker-controlled
  # origin or a javascript:/data: URI.
  YOUTUBE_EMBED_URL = %r{\Ahttps://www\.youtube\.com/embed/[\w-]{11}\z}
  YOUTUBE_ID = /\A[\w-]{11}\z/

  belongs_to :user
  has_many :movie_ratings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :avatar, dependent: :purge_later

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validate :trailer_url_must_be_youtube

  scope :recent_movies,  -> { order(released_at: :desc) }
  scope :popular_movies, -> { order(average_rating: :desc) }
  scope :movie_filter, lambda { |start_date = Date.yesterday, end_date = Time.zone.today|
    where(released_at: start_date..end_date)
  }
  scope :name_search, lambda { |query|
    next all if query.blank?

    # ESCAPE '\' makes sanitize_sql_like's backslash escaping effective on
    # SQLite/Postgres, so user-supplied % and _ are matched literally.
    where("LOWER(name) LIKE ? ESCAPE '\\'", "%#{sanitize_sql_like(query.downcase)}%")
  }

  before_validation :normalize_tags
  before_validation :canonicalize_trailer_url

  # Recomputes the denormalized average rating. update_column is intentional:
  # this is a cache of movie_ratings and must not fire validations/callbacks.
  def refresh_average_rating!
    update_column(:average_rating, movie_ratings.average(:rating))
  end

  # Returns the trailer URL only if it is a canonical YouTube embed URL,
  # otherwise nil. Views must use this (not trailer_url) as an <iframe> src so a
  # legacy/tampered row can never inject an arbitrary origin.
  def safe_trailer_embed_url
    trailer_url if trailer_url.to_s.match?(YOUTUBE_EMBED_URL)
  end

  # Builds a safe https://www.youtube.com/embed/<id> URL from any accepted
  # YouTube link shape, or nil if the input is not a YouTube video.
  def self.youtube_embed_url(raw)
    uri = URI.parse(raw.to_s.strip)
    return unless uri.is_a?(URI::HTTP) # http/https only — rejects javascript:, data:, etc.

    id =
      case uri.host&.delete_prefix('www.')&.delete_prefix('m.')
      when 'youtu.be'    then uri.path.delete_prefix('/')
      when 'youtube.com' then youtube_id_from(uri)
      end

    "https://www.youtube.com/embed/#{id}" if id&.match?(YOUTUBE_ID)
  rescue URI::InvalidURIError
    nil
  end

  def self.youtube_id_from(uri)
    if uri.path == '/watch'
      Rack::Utils.parse_query(uri.query)['v']
    elsif uri.path.start_with?('/embed/')
      uri.path.split('/')[2]
    end
  end

  private

  def canonicalize_trailer_url
    return if trailer_url.blank?

    # Leave invalid input in place so the validation below rejects the record.
    embed = self.class.youtube_embed_url(trailer_url)
    self.trailer_url = embed if embed
  end

  def trailer_url_must_be_youtube
    return if trailer_url.blank?
    return if trailer_url.match?(YOUTUBE_EMBED_URL)

    errors.add(:trailer_url, 'must be a valid YouTube link')
  end

  def normalize_tags
    self.tag_list =
      case tag_list
      when Array  then tag_list.map(&:strip).compact_blank
      when String then tag_list.split(',').map(&:strip).compact_blank
      else tag_list
      end
  end
end
