class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
  has_many :recipes, through: :menu_recipes

  accepts_nested_attributes_for :menu_recipes, allow_destroy: true

  validates :name, presence: true, length: { maximum: 255 }
end
