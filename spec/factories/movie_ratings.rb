# frozen_string_literal: true

FactoryBot.define do
  factory :movie_rating do
    association :movie
    association :user
    rating { 4 }
  end
end
