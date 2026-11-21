# frozen_string_literal: true

# Idempotent demo data so a freshly created database (e.g. `rails db:setup` or
# `docker compose up`) is immediately useful for testing every feature:
# discovery (sort/genre), watchlist, profiles, ratings, reviews & engagement.
#
# Demo logins (all password: password123):
#   demo@example.com · alice@example.com · ben@example.com

USERS = [
  ['demo@example.com',  'Demo',  'User'],
  ['alice@example.com', 'Alice', 'Nguyen'],
  ['ben@example.com',   'Ben',   'Carter']
].freeze

users = USERS.map do |email, first, last|
  User.find_or_create_by!(email: email) do |u|
    u.first_name = first
    u.last_name  = last
    u.password   = 'password123'
  end
end
demo = users.first

# [name, year, genres, director, runtime(min), trailer_id (nil = none), synopsis]
MOVIES = [
  ['Inception', 2010, 'Sci-Fi, Thriller', 'Christopher Nolan', 148, 'YoHD9XEInc0', "A thief who steals secrets through dream-sharing must plant an idea in a target's mind."],
  ['Interstellar', 2014, 'Sci-Fi, Drama', 'Christopher Nolan', 169, 'zSWdZVtXT7E', "Explorers travel through a wormhole in a bid to ensure humanity's survival."],
  ['The Dark Knight', 2008, 'Action, Crime', 'Christopher Nolan', 152, 'EXeTwQWrcwY', 'Batman faces the Joker, a mastermind who wants to plunge Gotham into anarchy.'],
  ['Parasite', 2019, 'Drama, Thriller', 'Bong Joon-ho', 132, '5xH0HfJHsaY', 'Greed and class strain the bond between a wealthy family and a destitute clan.'],
  ['The Shawshank Redemption', 1994, 'Drama', 'Frank Darabont', 142, nil, 'Two imprisoned men bond over years, finding solace and eventual redemption.'],
  ['The Godfather', 1972, 'Crime, Drama', 'Francis Ford Coppola', 175, nil, 'The aging patriarch of a crime dynasty transfers control to his reluctant son.'],
  ['Pulp Fiction', 1994, 'Crime, Drama', 'Quentin Tarantino', 154, nil, "The lives of hit men, a boxer and a gangster's wife interweave in four tales."],
  ['Fight Club', 1999, 'Drama, Thriller', 'David Fincher', 139, nil, 'An insomniac office worker and a soap maker form an underground fight club.'],
  ['Forrest Gump', 1994, 'Drama, Romance', 'Robert Zemeckis', 142, nil, 'A slow-witted but kind man witnesses and shapes decades of American history.'],
  ['The Matrix', 1999, 'Sci-Fi, Action', 'The Wachowskis', 136, nil, 'A hacker learns reality is a simulation and joins a rebellion against the machines.'],
  ['Goodfellas', 1990, 'Crime, Drama', 'Martin Scorsese', 145, nil, 'The rise and fall of a mob associate across three decades of New York crime.'],
  ['The Lord of the Rings: The Fellowship of the Ring', 2001, 'Fantasy, Adventure', 'Peter Jackson', 178, nil, 'A hobbit sets out to destroy a powerful ring and the dark lord who created it.'],
  ['Se7en', 1995, 'Crime, Thriller', 'David Fincher', 127, nil, 'Two detectives hunt a serial killer who uses the seven deadly sins as motifs.'],
  ['Gladiator', 2000, 'Action, Drama', 'Ridley Scott', 155, nil, 'A betrayed Roman general seeks revenge as a gladiator in the arena.'],
  ['The Silence of the Lambs', 1991, 'Crime, Thriller', 'Jonathan Demme', 118, nil, 'A young FBI trainee seeks the help of an imprisoned cannibal to catch a killer.'],
  ['Whiplash', 2014, 'Drama, Music', 'Damien Chazelle', 106, nil, 'A young drummer is pushed to his limits by a ruthless music instructor.'],
  ['The Prestige', 2006, 'Drama, Mystery', 'Christopher Nolan', 130, nil, 'Two rival magicians engage in a dangerous battle of one-upmanship.'],
  ['The Departed', 2006, 'Crime, Thriller', 'Martin Scorsese', 151, nil, 'A cop and a mole race to identify each other inside the Boston mob.'],
  ['Django Unchained', 2012, 'Western, Drama', 'Quentin Tarantino', 165, nil, 'A freed slave and a bounty hunter set out to rescue his wife from a plantation.'],
  ['Avengers: Endgame', 2019, 'Action, Sci-Fi', 'Russo Brothers', 181, nil, 'The remaining Avengers attempt to reverse the damage done by Thanos.'],
  ['Joker', 2019, 'Crime, Drama', 'Todd Phillips', 122, nil, "A failed comedian's descent into madness ignites a movement in Gotham."],
  ['Spirited Away', 2001, 'Animation, Fantasy', 'Hayao Miyazaki', 125, nil, 'A girl wanders into a spirit world and must work to free her parents.'],
  ['Your Name', 2016, 'Animation, Romance', 'Makoto Shinkai', 106, nil, 'Two teenagers mysteriously swap bodies and form a profound connection.'],
  ['The Lion King', 1994, 'Animation, Adventure', 'Roger Allers', 88, nil, 'A young lion prince flees his kingdom only to learn the meaning of responsibility.'],
  ['Toy Story', 1995, 'Animation, Comedy', 'John Lasseter', 81, nil, 'A cowboy doll is threatened when a spaceman toy supplants him as top toy.'],
  ['Coco', 2017, 'Animation, Family', 'Lee Unkrich', 105, nil, "A boy journeys to the Land of the Dead to uncover his family's history."],
  ['Mad Max: Fury Road', 2015, 'Action, Sci-Fi', 'George Miller', 120, nil, 'In a desert wasteland, rebels flee a tyrant in a relentless convoy chase.'],
  ['Blade Runner 2049', 2017, 'Sci-Fi, Drama', 'Denis Villeneuve', 164, nil, 'A young blade runner uncovers a secret that could plunge society into chaos.'],
  ['Dune', 2021, 'Sci-Fi, Adventure', 'Denis Villeneuve', 155, nil, 'A noble family becomes embroiled in a war for a precious desert resource.'],
  ['No Country for Old Men', 2007, 'Crime, Thriller', 'Coen Brothers', 122, nil, "A hunter's discovery of drug money triggers a relentless cat-and-mouse chase."],
  ['The Grand Budapest Hotel', 2014, 'Comedy, Drama', 'Wes Anderson', 99, nil, 'A legendary concierge and his protege become entangled in a theft and a fortune.'],
  ['La La Land', 2016, 'Romance, Music', 'Damien Chazelle', 128, nil, 'A jazz pianist and an aspiring actress fall in love while chasing their dreams.'],
  ['1917', 2019, 'War, Drama', 'Sam Mendes', 119, nil, 'Two soldiers race against time to deliver a message that could save hundreds.'],
  ['The Social Network', 2010, 'Drama, Biography', 'David Fincher', 120, nil, 'The founding of Facebook and the lawsuits that followed its explosive rise.'],
  ['Oldboy', 2003, 'Action, Thriller', 'Park Chan-wook', 120, nil, 'A man imprisoned for 15 years seeks answers after a sudden release.'],
  ['Amelie', 2001, 'Comedy, Romance', 'Jean-Pierre Jeunet', 122, nil, 'A shy Parisian waitress decides to change the lives of those around her.'],
  ['Inglourious Basterds', 2009, 'War, Drama', 'Quentin Tarantino', 153, nil, 'In Nazi-occupied France, two plots to assassinate the leadership converge.'],
  ['The Wolf of Wall Street', 2013, 'Comedy, Crime', 'Martin Scorsese', 180, nil, "A stockbroker's rise to wealth is fueled by fraud, excess and corruption."],
  ['Arrival', 2016, 'Sci-Fi, Drama', 'Denis Villeneuve', 116, nil, 'A linguist is recruited to communicate with newly arrived alien visitors.'],
  ['Everything Everywhere All at Once', 2022, 'Sci-Fi, Comedy', 'Daniels', 139, nil, 'A laundromat owner is swept into a multiverse adventure to save existence.']
].freeze

REVIEW_LINES = [
  'An absolute masterpiece — I was hooked from the first minute.',
  'Great performances, though it dragged a little in the middle.',
  'A modern classic that rewards a second watch.',
  "Visually stunning, with a soundtrack I can't stop replaying.",
  'Overhyped for me, but still a solid watch.',
  'The ending completely changes everything you thought you knew.'
].freeze

MOVIES.each_with_index do |(name, year, genres, director, runtime, trailer, synopsis), i|
  movie = Movie.find_or_create_by!(name: name) do |m|
    m.user        = demo
    m.released_at = Date.new(year, (i % 12) + 1, (i % 27) + 1)
    m.tag_list    = genres
    m.director    = director
    m.runtime     = runtime
    m.trailer_url = ("https://www.youtube.com/watch?v=#{trailer}" if trailer)
    m.description = synopsis
  end

  # Varied ratings from 1–3 users so averages and the breakdown differ.
  base = 3 + (i % 3)
  users.first(1 + (i % 3)).each_with_index do |user, j|
    score = (base - j + (i % 2)).clamp(1, 5)
    movie.movie_ratings.find_or_create_by!(user: user) { |r| r.rating = score }
  end

  # A review from a rotating author; roughly every 7th is a spoiler.
  author = users[i % users.size]
  movie.reviews.find_or_create_by!(about: REVIEW_LINES[i % REVIEW_LINES.size]) do |r|
    r.user    = author
    r.spoiler = (i % 7).zero?
  end

  movie.refresh_average_rating!
end

# Seed a watchlist for the demo user.
Movie.order(:name).limit(8).find_each do |movie|
  demo.watchlist_items.find_or_create_by!(movie: movie)
end

Rails.logger.debug do
  "Seeded #{User.count} users, #{Movie.count} movies, #{MovieRating.count} ratings, " \
    "#{Review.count} reviews, #{WatchlistItem.count} watchlist items."
end
