# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Engagement models', type: :model do
  let(:user)   { create(:user) }
  let(:movie)  { create(:movie) }
  let(:review) { create(:review, movie: movie, user: user) }

  describe WatchlistItem do
    it 'is unique per user and movie' do
      create(:watchlist_item, user: user, movie: movie)
      expect(build(:watchlist_item, user: user, movie: movie)).not_to be_valid
    end
  end

  describe ReviewHelpfulVote do
    it 'allows only one vote per user per review' do
      review.review_helpful_votes.create!(user: user)
      expect(review.review_helpful_votes.build(user: user)).not_to be_valid
    end
  end

  describe ReviewReport do
    it 'requires a reason from the allowed list' do
      expect(build_report(reason: 'nonsense')).not_to be_valid
      expect(build_report(reason: ReviewReport::REASONS.first)).to be_valid
    end

    it 'prevents a user reporting the same review twice' do
      create_report(reason: ReviewReport::REASONS.first)
      expect(build_report(reason: ReviewReport::REASONS.last)).not_to be_valid
    end

    def build_report(**attrs)  = review.review_reports.build(user: user, **attrs)
    def create_report(**attrs) = review.review_reports.create!(user: user, **attrs)
  end

  describe Movie do
    it ".sorted_by falls back to 'top' for an unknown key (no SQL injection)" do
      expect { described_class.sorted_by('junk; DROP TABLE movies').to_a }.not_to raise_error
    end

    it '#runtime_label formats minutes as hours and minutes' do
      expect(described_class.new(runtime: 142).runtime_label).to eq('2h 22m')
      expect(described_class.new(runtime: nil).runtime_label).to be_nil
    end

    it 'validates runtime is a positive integer' do
      expect(build(:movie, runtime: -5)).not_to be_valid
      expect(build(:movie, runtime: 120)).to be_valid
    end
  end
end
