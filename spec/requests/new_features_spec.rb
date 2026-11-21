# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Marketplace feature additions', type: :request do
  let(:owner)  { create(:user) }
  let(:viewer) { create(:user) }

  describe 'Richer movie pages' do
    it 'persists and renders description, director and runtime' do
      sign_in owner
      post movies_path, params: { movie: {
        name: 'Dune', released_at: '2021-10-22',
        director: 'Denis Villeneuve', runtime: 155,
        description: 'War for a desert planet.'
      } }
      movie = Movie.find_by(name: 'Dune')
      expect(movie).to have_attributes(director: 'Denis Villeneuve', runtime: 155)
      get movie_path(movie)
      expect(response.body).to include('Denis Villeneuve').and include('2h 35m').and include('desert planet')
    end
  end

  describe 'Smarter discovery' do
    before do
      sign_in viewer
      create(:movie, name: 'Aaa', average_rating: 1.0, released_at: Date.new(2024, 1, 1), tag_list: 'Drama')
      create(:movie, name: 'Zzz', average_rating: 5.0, released_at: Date.new(2000, 1, 1), tag_list: 'Action')
    end

    it 'sorts by newest' do
      get movies_path(sort: 'newest')
      expect(response.body.index('Aaa')).to be < response.body.index('Zzz')
    end

    it 'sorts by title A–Z' do
      get movies_path(sort: 'title')
      expect(response.body.index('Aaa')).to be < response.body.index('Zzz')
    end

    it 'filters by genre/tag' do
      get movies_path(genre: 'Action')
      expect(response.body).to include('Zzz')
      expect(response.body).not_to include('Aaa')
    end

    it 'ignores an unknown sort key (falls back safely)' do
      get movies_path(sort: "'; DROP TABLE movies; --")
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'Watchlist' do
    let(:movie) { create(:movie, user: owner) }

    it "toggles a movie on and off the current user's watchlist" do
      sign_in viewer
      expect { post watchlist_movie_path(movie) }.to change(WatchlistItem, :count).by(1)
      get watchlist_path
      expect(response.body).to include(movie.name)
      expect { post watchlist_movie_path(movie) }.to change(WatchlistItem, :count).by(-1)
    end

    it "keeps each user's watchlist private to them" do
      create(:watchlist_item, user: owner, movie: movie)
      sign_in viewer
      get watchlist_path
      expect(response.body).not_to include(movie.name) # viewer has not added it
    end
  end

  describe 'Review engagement' do
    let(:movie)  { create(:movie, user: owner) }
    let(:review) { create(:review, movie: movie, user: owner, about: 'Great!') }

    it 'records and toggles a helpful vote' do
      sign_in viewer
      expect { post helpful_movie_review_path(movie, review) }.to change(ReviewHelpfulVote, :count).by(1)
      expect { post helpful_movie_review_path(movie, review) }.to change(ReviewHelpfulVote, :count).by(-1)
    end

    it 'shows the helpful control with a count on the movie page' do
      create(:review, movie: movie, user: viewer, about: 'Loved it')
      sign_in viewer
      get movie_path(movie)
      expect(response.body).to include('Helpful')
    end

    it 'lets a user report a review once with a valid reason' do
      sign_in viewer
      expect do
        post report_movie_review_path(movie, review), params: { reason: ReviewReport::REASONS.first }
      end.to change(ReviewReport, :count).by(1)
      # a second identical report is rejected by the uniqueness rule
      expect do
        post report_movie_review_path(movie, review), params: { reason: ReviewReport::REASONS.first }
      end.not_to change(ReviewReport, :count)
    end

    it 'rejects a report with an invalid reason' do
      sign_in viewer
      post report_movie_review_path(movie, review), params: { reason: 'whatever' }
      expect(ReviewReport.count).to eq(0)
    end

    it 'stores the spoiler flag and hides spoiler text behind a toggle' do
      sign_in owner
      post movie_reviews_path(movie), params: { review: { about: 'Big twist!', spoiler: '1' } }
      expect(movie.reviews.last.spoiler).to be(true)
      get movie_path(movie)
      expect(response.body).to include('Spoiler').and include('<details')
    end
  end

  describe 'Public profiles' do
    it "shows a user's activity without leaking their email" do
      movie = create(:movie, user: owner)
      create(:review, movie: movie, user: owner, about: 'My take')
      sign_in viewer
      get user_path(owner)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(owner.display_name)
      expect(response.body).not_to include(owner.email)
    end
  end
end
