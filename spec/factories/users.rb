# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Karthik' }
    last_name  { 'R' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
  end
end
