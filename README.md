# Movie Review

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![RSpec](https://img.shields.io/badge/Tested_with-RSpec-brightgreen?style=flat)
![CI](https://github.com/karthik1210100/movie_review/actions/workflows/rubyonrails.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

A full-stack Ruby on Rails application for discovering and reviewing movies. Users sign up, browse a catalogue with posters and trailers, rate and review films, and discuss them through threaded comments — all behind role-based access control.

## What this project demonstrates

A complete server-rendered Rails app with the pieces a real product needs: authentication, authorization, file uploads, tagging, and a tested request layer.

- **Authentication done properly** — Devise with email confirmation, password reset, account unlock, and **OmniAuth social sign-in**.
- **Role-based authorization** — a single CanCanCan `Ability` model decides who can create, edit, or delete each resource.
- **Rich domain model** — movies carry poster images (Active Storage), trailer URLs, genre tags (`acts-as-taggable-on`), and a denormalized average rating.
- **Discussion** — reviews belong to users; comments thread onto reviews.
- **Tested** — RSpec request specs and mailer specs, with FactoryBot test data.

## ✨ Features

- Sign up / log in with email confirmation, password reset, and social (OmniAuth) login
- Browse movies with posters, trailers, and genre tags
- Write, edit, and delete reviews
- Rate movies and see the running average
- Threaded comments on reviews
- Permissions enforced per role with CanCanCan

## 🛠️ Built with

| Area | Tech |
|---|---|
| Framework | Ruby on Rails |
| Auth | Devise · OmniAuth |
| Authorization | CanCanCan |
| Files & media | Active Storage |
| Tagging | acts-as-taggable-on |
| Tests | RSpec · FactoryBot |

## 🏗️ Domain model

```
User ──< Review ──< Comment
 │          │
 │          └─ belongs_to Movie
 └──< Rating >── Movie ──< Taggings (genres)
                   └─ Active Storage poster + trailer URL + average_rating
```

## 🚀 Getting started

```bash
bundle install
rails db:setup        # create, load schema, seed
rails server          # http://localhost:3000
```

Run the test suite:

```bash
bundle exec rspec
```

## 📄 License

[MIT](./LICENSE) © Karthikeyan Subramanian
