# Development-oriented image for running the app locally with no host Ruby setup.
# (For production you'd use a multi-stage build with asset precompilation.)
# Pinned to the Debian bookworm variant for stable, known-correct package names.
FROM ruby:3.3.14-slim-bookworm

# System deps: build toolchain for native gems, SQLite, and libvips (>= 8.13)
# which Rails 8 Active Storage requires.
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        pkg-config \
        libsqlite3-0 \
        libsqlite3-dev \
        libvips42 \
        curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle

# Install gems first for better layer caching. Bundler auto-installs the version
# recorded in Gemfile.lock's "BUNDLED WITH" if it differs from the image default.
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

# Prepare the DB (create + schema load + seed on first run) and boot Puma on all
# interfaces so the host can reach it. Clears any stale PID from a previous run.
CMD ["bash", "-lc", "rm -f tmp/pids/server.pid && bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0 -p 3000"]
