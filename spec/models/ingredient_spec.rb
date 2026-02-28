require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:protein) }
  it { should validate_presence_of(:fat) }
  it { should validate_presence_of(:carb) }
  it { should validate_presence_of(:calories) }
end