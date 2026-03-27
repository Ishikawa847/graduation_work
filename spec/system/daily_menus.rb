require 'rails_helper'

RSpec.describe "献立登録", type: :system do
  let(:user) { create(:user) }
  let!(:menu) { create(:menu, user: user) }

  before do
    sign_in user
  end

  it "献立を登録できる" do
    visit new_daily_menu_path

    fill_in "日付", with: Date.today
    select menu.name, from: "献立"

    click_button "スケジュールを確定"

    expect(page).to have_content("献立を登録しました")
  end
end
