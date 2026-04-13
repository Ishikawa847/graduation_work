FactoryBot.define do
  factory :recipe_ingredient do
    association :recipe
    association :ingredient
    quantity { 100 }
  end
end
