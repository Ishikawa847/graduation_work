FactoryBot.define do
  factory :recipe do
    name { "テストレシピ" }
    description { "テスト用の説明です" }
    association :user

    after(:build) do |recipe|
      recipe.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/test.jpg")),
        filename: "test.jpg",
        content_type: "image/jpeg"
      )
    end
  end
end
