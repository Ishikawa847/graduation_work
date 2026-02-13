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
      format: :webp    )
  end

def square_image(size: 300)
  return unless image.attached?

  display_image(width: size, height: size)
end

def large_image(size: 800)
  return unless image.attached?

  display_image(width: size, height: size)
end

  def total_protein
    total_p = 0

    recipe_ingredients.includes(:ingredient).each do |ri|
      ing = ri.ingredient
      qty = ri.quantity.to_f

      total_p += ing.protein.to_f * qty / 100.0
    end
    total_p
  end

  def total_fat
    total_f = 0

    recipe_ingredients.includes(:ingredient).each do |ri|
      ing = ri.ingredient
      qty = ri.quantity.to_f

      total_f += ing.fat.to_f * qty / 100.0
    end
    total_f
  end

  def total_carb
    total_c = 0

    recipe_ingredients.includes(:ingredient).each do |ri|
      ing = ri.ingredient
      qty = ri.quantity.to_f

      total_c += ing.carb.to_f * qty / 100.0
    end
    total_c
  end

  def ogp_image_url(host:)
    if Rails.env.production?
      image.url(width: 1200, height: 630, crop: :fill)
    else
      Rails.application.routes.url_helpers.rails_blob_url(image, host: host)
    end
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
