class Recipe < ApplicationRecord
  has_one_attached :image

  validates :image, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 1000 }

  belongs_to :user, foreign_key: :user_id, primary_key: :uuid

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :menu_recipes, dependent: :destroy
  has_many :menus, through: :menu_recipes

  accepts_nested_attributes_for :recipe_ingredients,
                                allow_destroy: true,
                                reject_if: :reject_ingredient?

  def to_param
    uuid
  end
  private

  def reject_ingredient?(attributes)
    attributes["quantity"].blank? ||
  (attributes["ingredient_attributes"] &&
   attributes["ingredient_attributes"]["name"].blank?)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "name", "updated_at", "user_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "ingredients", "recipe_ingredients" ]
  end

end
