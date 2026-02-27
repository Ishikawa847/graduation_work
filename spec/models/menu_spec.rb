require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe "バリデーション" do
    it { should validate_presence_of(:name) }
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should have_many(:menu_recipes) }
  end
end
