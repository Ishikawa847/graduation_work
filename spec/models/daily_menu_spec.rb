require 'rails_helper'

RSpec.describe DailyMenu, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:menu) }
  end

  describe 'バリデーション' do
    subject { create(:daily_menu) }

    it { should validate_presence_of(:date) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:date) }
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
end
