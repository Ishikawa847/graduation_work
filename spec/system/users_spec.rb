require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ユーザー会員登録' do
    context '入力値が正常な場合' do
      it 'ユーザー登録が成功する' do
        visit new_user_registration_path

        fill_in '名前', with: 'ほげ'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード確認', with: 'password123'

        click_button '会員登録'

        #expect(page).to have_content 'ユーザー登録が完了しました'
        expect(current_path).to eq recipes_path
      end
    end
  end
end
