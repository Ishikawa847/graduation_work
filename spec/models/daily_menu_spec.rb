require 'rails_helper'

RSpec.describe DailyMenu, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:menu) }
  end

  describe 'バリデーション' do
    subject { create(:daily_menu) }

    it { should validate_presence_of(:date) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:date).ignoring_case_sensitivity }
  end

  describe '自作バリデーション' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:menu) { create(:menu, user: other_user) }

    it '他人のmenuは無効であること' do
      daily_menu = build(:daily_menu, user: user, menu: menu, date: Date.today)

      expect(daily_menu).to be_invalid
      expect(daily_menu.errors[:menu]).to include("は自分の献立ではありません")
    end
  end

  describe ".total_pfc" do
    it "PFC合計を正しく計算できる" do
    user = create(:user)
    menu = create(:menu, user: user)
    recipe = create(:recipe)

    create(:menu_recipe, menu: menu, recipe: recipe)

    ingredient = create(:ingredient, protein: 10, fat: 5, carb: 20)

    create(:recipe_ingredient,
      recipe: recipe,
      ingredient: ingredient,
      quantity: 100
    )

    create(:daily_menu, menu: menu, date: Date.today, user: user)
    create(:daily_menu, menu: menu, date: Date.tomorrow, user: user)

    result = DailyMenu.total_pfc(DailyMenu.all)

    expect(result[:protein]).to eq(20)
    expect(result[:fat]).to eq(10)
    expect(result[:carb]).to eq(40)
    end
  end
end
