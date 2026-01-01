require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it '名前、メールアドレス、パスワードがあれば有効である' do
      user = build(:user)  # FactoryBotで作成
      expect(user).to be_valid
    end

    it '名前がない場合、無効である' do
      user = build(:user, name: nil)  # nameだけnilに上書き
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end

    it 'メールアドレスががない場合、無効である' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it 'メールアドレスが重複する場合、無効である' do
      create(:user, email: 'test@example.com')

      user = build(:user, email: 'test@example.com')
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it '身長、体重、年齢、性別が無くても有効である' do
      user = build(:user, height: nil, weight: nil, age: nil, gender: nil)
      expect(user).to be_valid
    end
  end
end
