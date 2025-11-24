class Recipe < ApplicationRecord
  has_one_attached :image
  
  validates :image, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 1000 }

  belongs_to :user

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients 

  accepts_nested_attributes_for :recipe_ingredients, 
                                allow_destroy: true,
                                reject_if: :reject_ingredient?
end
