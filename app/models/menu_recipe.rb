class MenuRecipe < ApplicationRecord
  belongs_to :menu
  belongs_to :recipe

  default_scope { order(position: :asc) }

  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
