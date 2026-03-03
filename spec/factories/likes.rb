FactoryBot.define do
  factory :like do
    association :recipe
    association :user
  end
end
