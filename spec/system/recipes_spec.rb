require 'rails_helper'

RSpec.describe "Recipes", type: :system do
  let(:user) { create(:user) } 

  before do
    sign_in user
  end

  it "レシピを投稿できる" do
    visit new_recipe_path

    fill_in "レシピ名", with: "テストレシピ"
    fill_in "説明", with: "説明です"
    attach_file "image-upload",
                Rails.root.join("spec/fixtures/test.jpg"),
                make_visible: true

    click_button "投稿"

    expect(page).to have_content "テストレシピ"
  end
end