# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    sequence(:name) { |n| "Movie #{n}" }
    released_at { Date.new(2020, 1, 1) }
    association :user
  end
end
