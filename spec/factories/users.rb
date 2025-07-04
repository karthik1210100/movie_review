FactoryBot.define do
  factory :user do
    first_name { "Karthik" }
    last_name  { "R" }
    email { "email@gmail.com" }
    password { "password123" }
  end
end
