# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieRating, type: :model do
  let(:movie) { create(:movie) }
  let(:user)  { create(:user) }

  it 'accepts a rating within 1..5' do
    expect(build(:movie_rating, movie: movie, user: user, rating: 4)).to be_valid
  end

  it 'rejects a rating above 5 (prevents average poisoning)' do
    expect(build(:movie_rating, movie: movie, user: user, rating: 6)).not_to be_valid
  end

  it 'rejects a rating below 1' do
    expect(build(:movie_rating, movie: movie, user: user, rating: 0)).not_to be_valid
  end

  it 'rejects a non-integer rating' do
    expect(build(:movie_rating, movie: movie, user: user, rating: 3.5)).not_to be_valid
  end

  it 'allows only one rating per user per movie' do
    create(:movie_rating, movie: movie, user: user, rating: 3)
    expect(build(:movie_rating, movie: movie, user: user, rating: 5)).not_to be_valid
  end
end
