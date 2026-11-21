# Movie Review

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-8.1-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![Ruby](https://img.shields.io/badge/Ruby-3.3-CC342D?style=flat&logo=ruby&logoColor=white)
![RSpec](https://img.shields.io/badge/Tested_with-RSpec-brightgreen?style=flat)
![Brakeman](https://img.shields.io/badge/SAST-Brakeman-blue?style=flat)

A full-stack movie review web application built with Ruby on Rails, where users can
browse movies, write and rate reviews, and discuss them through comments.

## ✨ Features

- User accounts (Devise) with public **profile pages** (ratings & reviews, never the email)
- Rich movie pages: **synopsis, director, runtime, poster**, tags and trailer
- **Discovery**: sort (top-rated / newest / A–Z), one-click **genre filter**, name search & date range
- Write, edit, delete reviews — with **spoiler tags**, **helpful votes**, **report-a-review**, and threaded comments
- Rate movies (1–5, one per user) with a denormalized average and rating breakdown
- **Watchlist** — save movies to watch later
- YouTube trailer embedding (validated to canonical embed URLs, sandboxed iframe)
- Role/ownership-based authorization (CanCanCan) and **Rack::Attack rate limiting** on auth

## 🛠️ Built with

- Ruby 3.3 · Ruby on Rails 8.1
- Active Record / Active Storage · SQLite
- Devise (authentication) · CanCanCan (authorization)
- Hotwire (Turbo + Stimulus) · importmap
- RSpec + FactoryBot (tests) · Brakeman + bundler-audit + RuboCop (CI gates)

## 🚀 Getting started

### Option A — Docker (no local Ruby needed)

```bash
docker compose up --build
```

Then open **http://localhost:3100**. The database is created and seeded automatically.
(Host port is `3100` to avoid clashing with anything on `3000`; override with
`HOST_PORT=4000 docker compose up --build`.)

### Option B — Local Ruby

Requires Ruby (see `.ruby-version`) and **libvips ≥ 8.13** (Active Storage image
processing). On Ubuntu: `sudo apt-get install -y libvips42`; on macOS: `brew install vips`.

```bash
bundle install
bin/rails db:setup   # create + load schema + seed
bin/rails server     # runs at http://localhost:3000
```

### Demo login

```
demo@example.com / password123
```

## ✅ Quality & security checks

```bash
bundle exec rspec                       # test suite
bundle exec rubocop                     # style + security cops
bundle exec brakeman --no-pager         # static application security testing
bundle exec bundle-audit check --update # dependency CVE scan
```

These run automatically in CI (`.github/workflows/rubyonrails.yml`). A full write-up of
the security review is in [`SECURITY_REVIEW.md`](SECURITY_REVIEW.md).
