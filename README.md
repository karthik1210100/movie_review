<div align="center">

# Movie Review

**A production-style Ruby on Rails app — authentication, role-based authorization, Active Storage media, tagging, and a tested request layer.**

[![CI](https://img.shields.io/github/actions/workflow/status/karthik1210100/movie_review/rubyonrails.yml?branch=main&style=for-the-badge&label=CI&logo=github)](https://github.com/karthik1210100/movie_review/actions/workflows/rubyonrails.yml)
&nbsp;
[![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=rubyonrails&logoColor=white)](https://rubyonrails.org)
&nbsp;
[![RSpec](https://img.shields.io/badge/Tested_with-RSpec-5a6350?style=for-the-badge)](https://rspec.info)
&nbsp;
[![License: MIT](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

[Features](#features) &middot; [Built with](#built-with) &middot; [Domain model](#domain-model) &middot; [Getting started](#getting-started)

</div>

---

## What it is

A full-stack, server-rendered Rails app for discovering and reviewing movies. You sign up, browse a catalogue with posters and trailers, rate and review films, and discuss them through threaded comments — all behind role-based access control.

It's a portfolio project built to show the pieces a real Rails product needs, wired together properly: authentication, authorization, file uploads, tagging, counter-cached aggregates, and a tested request layer.

## Features

- **Accounts** — sign up and log in with Devise, with password reset and remember-me.
- **Movies** — each film has a poster (Active Storage), a trailer URL, genre tags, and a release date.
- **Reviews** — write, edit, and delete reviews on any movie.
- **Ratings** — rate a movie and see its running average, kept fast with a counter cache.
- **Threaded comments** — discuss a review in a nested comment thread.
- **Role-based access** — one CanCanCan `Ability` decides who can create, edit, or delete each resource.
- **Tested** — RSpec request and mailer specs with FactoryBot data, run on every push via GitHub Actions.

## Built with

| Area | Tech |
|---|---|
| Framework | Ruby on Rails (server-rendered, MVC) |
| Auth | Devise |
| Authorization | CanCanCan |
| Media & files | Active Storage + image_processing |
| Tagging | acts-as-taggable-on |
| Database | SQLite (dev / test) |
| Tests & CI | RSpec &middot; FactoryBot &middot; GitHub Actions |

## Domain model

```
User ──< Review ──< Comment      a user writes reviews; comments thread onto a review
User ──< Rating >── Movie         ratings link users and movies
Movie ──< Taggings (genres)       genres via acts-as-taggable-on

Movie: Active Storage poster · trailer_url · average_rating (+ counter cache)
```

## Getting started

```bash
bundle install
rails db:setup        # create, load schema, and seed
rails server          # http://localhost:3000
```

Run the test suite:

```bash
bundle exec rspec
```

## Project layout

```
app/
  models/        User, Movie, Review, Rating, Comment, Ability
  controllers/   movies, reviews, ratings, comments + Devise controllers
spec/
  requests/      request specs
  mailers/       mailer specs
.github/workflows/rubyonrails.yml   CI
```

## License

MIT — see [LICENSE](LICENSE). © Karthikeyan Subramanian

---

<div align="center">

Built by [Karthikeyan Subramanian](https://github.com/karthik1210100) &middot; [LinkedIn](https://www.linkedin.com/in/karthik-webdev/) &middot; [Portfolio](https://karthik1210100.github.io/portfolio_2026/)

If this is a useful Rails reference, a ⭐ is appreciated.

[![Star](https://img.shields.io/github/stars/karthik1210100/movie_review?style=social)](https://github.com/karthik1210100/movie_review/stargazers)

</div>
