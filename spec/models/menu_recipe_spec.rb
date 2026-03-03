require 'rails_helper'

RSpec.describe MenuRecipe, type: :model do
  it { should belong_to(:menu) }
  it { should belong_to(:recipe) }
  it { should validate_presence_of(:position) }
end