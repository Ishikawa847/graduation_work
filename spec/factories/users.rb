FactoryBot.define do
  factory :user do
    name { 'ほげ' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    height { 170.5 }
    weight { 65.0 }
    age { 25 }
    gender { 1 }
  end
end
