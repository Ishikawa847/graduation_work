require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  it { should belong_to(:recipe) }
  it { should belong_to(:ingredient) }
  it { should validate_presence_of(:quantity) }
end
