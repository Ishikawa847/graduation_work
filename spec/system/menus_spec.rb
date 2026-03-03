# spec/system/menus_spec.rb
require "rails_helper"

RSpec.describe "献立管理", type: :system do
  let(:user) { create(:user) }
  let!(:recipe1) { create(:recipe, user: user, name: "カレー") }
  let!(:recipe2) { create(:recipe, user: user, name: "サラダ") }

  before do
    sign_in user
  end

  it "献立を作成できる" do
    visit new_menu_path

    fill_in "menu_name", with: "今日の晩ごはん"

    select "カレー", from: "menu_menu_recipes_attributes_0_recipe_id"
    fill_in "menu_menu_recipes_attributes_0_position", with: 1

    click_button I18n.t("menus.new.submit")

    expect(page).to have_content "今日の晩ごはん"
  end

    it "献立を編集できる" do
      menu = create(:menu, user: user, name: "今日の晩ごはん")

      visit menus_path

      within("tr", text: "今日の晩ごはん") do
        click_link "編集"
      end

      fill_in "menu_name", with: "減量メニュー"
      click_button "更新"

      expect(page).to have_current_path(menu_path(menu))
      expect(page).to have_content "減量メニュー"
      expect(page).not_to have_content "今日の晩ごはん"
    end
  it "献立を削除できる" do
    menu = create(:menu, user: user, name: "今日の晩ごはん")

    visit menus_path

    expect {
      within("tr", text: "今日の晩ごはん") do
        click_link "削除"
      end
      page.accept_confirm
      expect(page).to have_current_path(menus_path)
    }.to change(Menu, :count).by(-1)

    expect(page).not_to have_content "今日の晩ごはん"
  end
end