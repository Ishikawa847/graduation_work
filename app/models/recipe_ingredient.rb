class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :recipe_id, uniqueness: { scope: :ingredient_id }

  attr_accessor :name, :protein, :fat, :carb

  #accepts_nested_attributes_for :ingredient

end
