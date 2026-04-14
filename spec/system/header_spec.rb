require 'rails_helper'

RSpec.describe 'Header', type: :system do
let(:user) { create(:user) }
  before do
    sign_in user
  end
  it 'ヘッダーのカレンダーボタンを押すとカレンダーページに遷移する' do
    visit root_path

    click_link 'カレンダー'

    expect(page).to have_current_path(calendar_path)
  end
end