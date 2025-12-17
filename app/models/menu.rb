class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
  has_many :recipes, through: :menu_recipes

  accepts_nested_attributes_for :menu_recipes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, length: { maximum: 255 }

  def total_protein
    recipes.joins(:recipe_ingredients, :ingredients)
    .sum('ingredients.protein * recipe_ingredients.quantity / 100.0')
  end

  def total_fat
    recipes.joins(:recipe_ingredients, :ingredients)
    .sum('ingredients.fat * recipe_ingredients.quantity / 100.0')
  end

  def total_carb
    recipes.joins(:recipe_ingredients, :ingredients)
    .sum('ingredients.carb * recipe_ingredients.quantity / 100.0')
  end
end
