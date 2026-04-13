FactoryBot.define do
  factory :menu_recipe do
    association :menu
    association :recipe
    position { 1 }
  end
end