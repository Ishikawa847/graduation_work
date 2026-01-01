class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: true
  validates :protein, :fat, :carb, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
