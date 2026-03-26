FactoryBot.define do
  factory :daily_menu do
    association :user
    menu { association :menu, user: user }
    date { "2026-03-25" }
  end
end
