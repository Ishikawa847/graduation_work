FactoryBot.define do
  factory :menu do
    association :user
    name { "テスト献立" }
  end
end
