# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    association :movie
    association :user
    about { 'A thoughtful review of this film.' }
    spoiler { false }
  end
end
