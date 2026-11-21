# frozen_string_literal: true

FactoryBot.define do
  factory :watchlist_item do
    association :user
    association :movie
  end
end
