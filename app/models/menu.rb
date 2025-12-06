class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
  has_many :recipes, through: :menu_recipes

  validates :name, presence: true, length: { maximum: 255 }
end
