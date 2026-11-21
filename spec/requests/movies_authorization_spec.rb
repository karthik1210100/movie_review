# frozen_string_literal: true

require 'rails_helper'

# Regression tests for the broken-access-control (IDOR) fix: a signed-in user
# must never be able to modify or delete another user's movie.
RSpec.describe 'Movies authorization', type: :request do
  let(:owner)    { create(:user) }
  let(:attacker) { create(:user) }
  let!(:movie)   { create(:movie, user: owner, name: 'Owned Movie') }

  describe 'unauthenticated access' do
    it 'redirects to sign in' do
      get movies_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'a non-owner' do
    before { sign_in attacker }

    it "cannot update another user's movie" do
      patch movie_path(movie), params: { movie: { name: 'Hijacked' } }
      expect(response).to redirect_to(root_path)
      expect(movie.reload.name).to eq('Owned Movie')
    end

    it "cannot delete another user's movie" do
      expect do
        delete movie_path(movie)
      end.not_to change(Movie, :count)
      expect(response).to redirect_to(root_path)
    end

    it 'may still browse' do
      get movie_path(movie)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'the owner' do
    before { sign_in owner }

    it 'can update their own movie' do
      patch movie_path(movie), params: { movie: { name: 'Updated' } }
      expect(movie.reload.name).to eq('Updated')
    end

    it 'can delete their own movie' do
      expect do
        delete movie_path(movie)
      end.to change(Movie, :count).by(-1)
    end
  end

  describe 'rating bounds enforcement' do
    before { sign_in attacker }

    it 'ignores an out-of-range rating' do
      post movie_rating_movie_path(movie), params: { movie: { rating: 99 } }
      expect(movie.movie_ratings.where(rating: 99)).to be_empty
    end

    it 'persists a valid rating and refreshes the average' do
      post movie_rating_movie_path(movie), params: { movie: { rating: 5 } }
      expect(movie.movie_ratings.find_by(user: attacker).rating).to eq(5)
      expect(movie.reload.average_rating).to eq(5.0)
    end
  end
end
