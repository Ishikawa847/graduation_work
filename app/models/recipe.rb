class Recipe < ApplicationRecord
  has_one_attached :image

  validates :image, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 1000 }

  belongs_to :user

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :menu_recipes, dependent: :destroy
  has_many :menus, through: :menu_recipes

  accepts_nested_attributes_for :recipe_ingredients,
                                allow_destroy: true,
                                reject_if: :reject_ingredient?

  def display_image(width: 800, height: 600)
    return unless image.attached?
    
    image.variant(
      resize_to_fill: [width, height],  
      format: :webp,
      saver: { quality: 85 }  
    )
  end

  def thumbnail_image
    display_image(width: 300, height: 300)
  end

  private

  def reject_ingredient?(attributes)
    # ingredient_idが空 かつ quantityが空 かつ 新規材料の名前も空の場合は拒否
    attributes["ingredient_id"].blank? &&
    attributes["quantity"].blank? &&
    (attributes["ingredient_attributes"].nil? ||
     attributes["ingredient_attributes"]["name"].blank?)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "name", "updated_at", "user_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "ingredients", "recipe_ingredients" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "name", "updated_at", "user_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "ingredients", "recipe_ingredients" ]
  end
end
