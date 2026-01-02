require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do
    context '正しい情報を入力した場合' do
      it 'ログインできること' do
        visit new_user_session_path

        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password123'
        click_button 'ログイン'

        expect(page).to have_content('ログインしました')
        expect(page).to have_current_path(recipes_path)
        expect(page).to have_link('ログアウト')
      end
    end

    context '間違った情報を入力した場合' do
      it 'ログインできないこと' do
        visit new_user_session_path

        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'wrong_password'
        click_button 'ログイン'

        expect(page).to have_content('メールアドレスまたはパスワードが正しくありません')
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  describe 'ログアウト' do
    before do
      sign_in user
    end

    it 'ログアウトできること' do
      visit recipes_path
      click_link 'ログアウト'

      expect(page).to have_content('ログアウトしました')
      expect(page).to have_current_path(root_path)
      expect(page).to have_link('ログイン')
    end
  end
end
