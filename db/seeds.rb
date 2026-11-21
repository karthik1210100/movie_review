# frozen_string_literal: true

# Idempotent demo data so a freshly created database (e.g. `rails db:setup` or
# `docker compose up`) is usable immediately.
#
# Demo login:  demo@example.com  /  password123

demo = User.find_or_create_by!(email: "demo@example.com") do |u|
  u.first_name = "Demo"
  u.last_name  = "User"
  u.password   = "password123"
end

MOVIES = [
  ["Inception",       "2010-07-16", "Sci-Fi, Thriller", "https://www.youtube.com/watch?v=YoHD9XEInc0", 5],
  ["Interstellar",    "2014-11-07", "Sci-Fi, Drama",    "https://www.youtube.com/watch?v=zSWdZVtXT7E", 4],
  ["The Dark Knight", "2008-07-18", "Action, Crime",    "https://youtu.be/EXeTwQWrcwY",                5],
  ["Parasite",        "2019-11-08", "Drama, Thriller",  "https://www.youtube.com/watch?v=5xH0HfJHsaY", 4]
].freeze

MOVIES.each do |name, released_at, tags, trailer, rating|
  movie = Movie.find_or_create_by!(name: name) do |m|
    m.user        = demo
    m.released_at = Date.parse(released_at)
    m.tag_list    = tags
    m.trailer_url = trailer
  end
  movie.movie_ratings.find_or_create_by!(user: demo) { |r| r.rating = rating }
  movie.reviews.find_or_create_by!(about: "A genuinely great film — highly recommended.") { |r| r.user = demo }
  movie.refresh_average_rating!
end

puts "Seeded #{User.count} user(s), #{Movie.count} movie(s), #{Review.count} review(s)."
