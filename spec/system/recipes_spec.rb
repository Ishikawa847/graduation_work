require 'rails_helper'

RSpec.describe "Recipes", type: :system do
  let(:user) { create(:user) } 
  let!(:recipe) { create(:recipe, user: user) }

  before do
    sign_in user
  end

  describe "レシピ作成" do
    it "正常に投稿できる" do
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

  describe "レシピ編集" do
    it "編集できる" do
      visit edit_recipe_path(recipe)

      fill_in "レシピ名", with: "編集後レシピ"
      click_button "レシピを更新"

      expect(page).to have_current_path(recipe_path(recipe))
    end
  end

  describe "レシピ削除" do
    it "削除できる", js: true do
      visit profile_path

    expect(page).to have_content recipe.name
    expect(page).to have_link("削除")

    accept_confirm do
      click_link "削除"
    end

    expect(page).to have_content "削除しました"
    expect(page).not_to have_content recipe.name
    expect(Recipe.exists?(recipe.id)).to be false
    end
  end
end