FactoryBot.define do
  factory :ingredient do
    name { "鶏むね肉" }
    protein { 10 }
    fat     { 5 }
    carb    { 0 }
    calories { 150 }
  end
end