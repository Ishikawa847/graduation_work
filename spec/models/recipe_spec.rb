require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe "バリデーション" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:image) }
  end

  describe "アソシエーション" do
    it { should belong_to(:user) }
    it { should have_many(:recipe_ingredients) }
  end
end
