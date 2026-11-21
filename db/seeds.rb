# frozen_string_literal: true

# Idempotent demo data so a freshly created database (e.g. `rails db:setup` or
# `docker compose up`) is usable immediately.
#
# Demo login:  demo@example.com  /  password123

demo = User.find_or_create_by!(email: 'demo@example.com') do |u|
  u.first_name = 'Demo'
  u.last_name  = 'User'
  u.password   = 'password123'
end

MOVIES = [
  { name: 'Inception', released_at: '2010-07-16', tags: 'Sci-Fi, Thriller', rating: 5,
    director: 'Christopher Nolan', runtime: 148, trailer: 'https://www.youtube.com/watch?v=YoHD9XEInc0',
    description: 'A thief who steals secrets via dream-sharing must plant an idea in a target\'s mind.' },
  { name: 'Interstellar', released_at: '2014-11-07', tags: 'Sci-Fi, Drama', rating: 4,
    director: 'Christopher Nolan', runtime: 169, trailer: 'https://www.youtube.com/watch?v=zSWdZVtXT7E',
    description: 'Explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.' },
  { name: 'The Dark Knight', released_at: '2008-07-18', tags: 'Action, Crime', rating: 5,
    director: 'Christopher Nolan', runtime: 152, trailer: 'https://youtu.be/EXeTwQWrcwY',
    description: 'Batman faces the Joker, a criminal mastermind who wants to plunge Gotham City into anarchy.' },
  { name: 'Parasite', released_at: '2019-11-08', tags: 'Drama, Thriller', rating: 4,
    director: 'Bong Joon-ho', runtime: 132, trailer: 'https://www.youtube.com/watch?v=5xH0HfJHsaY',
    description: 'Greed and class discrimination threaten the bond between a wealthy family and a destitute clan.' }
].freeze

MOVIES.each do |attrs|
  movie = Movie.find_or_create_by!(name: attrs[:name]) do |m|
    m.user        = demo
    m.released_at = Date.parse(attrs[:released_at])
    m.tag_list    = attrs[:tags]
    m.trailer_url = attrs[:trailer]
    m.director    = attrs[:director]
    m.runtime     = attrs[:runtime]
    m.description = attrs[:description]
  end
  movie.movie_ratings.find_or_create_by!(user: demo) { |r| r.rating = attrs[:rating] }
  movie.reviews.find_or_create_by!(about: 'A genuinely great film — highly recommended.') { |r| r.user = demo }
  movie.refresh_average_rating!
end

Rails.logger.debug { "Seeded #{User.count} user(s), #{Movie.count} movie(s), #{Review.count} review(s)." }
