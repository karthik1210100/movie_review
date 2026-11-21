# Movie Review

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-8.1-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![Ruby](https://img.shields.io/badge/Ruby-3.3-CC342D?style=flat&logo=ruby&logoColor=white)
![RSpec](https://img.shields.io/badge/Tested_with-RSpec-brightgreen?style=flat)
![Brakeman](https://img.shields.io/badge/SAST-Brakeman-blue?style=flat)

A full-stack movie review web application built with Ruby on Rails, where users can
browse movies, write and rate reviews, and discuss them through comments.

## ✨ Features

- User accounts (Devise)
- Browse and manage movies (image uploads via Active Storage, tags via acts-as-taggable-on)
- Write, edit, and delete reviews — and comment on reviews
- Rate movies (1–5, one rating per user) with a denormalized average
- YouTube trailer embedding (validated to canonical embed URLs)
- Role/ownership-based authorization with CanCanCan

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

Then open **http://localhost:3000**. The database is created and seeded automatically.

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
