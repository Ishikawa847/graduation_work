class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :recipe_id, uniqueness: { scope: :ingredient_id }

  attr_accessor :ingredient_name, :protein_per_100g, :fat_per_100g, :carbohydrate_per_100g
end
