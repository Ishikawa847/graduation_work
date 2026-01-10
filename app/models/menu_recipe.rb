class MenuRecipe < ApplicationRecord
  belongs_to :menu, foreign_key: :menu_id, primary_key: :uuid
  belongs_to :recipe, foreign_key: :recipe_id, primary_key: :uuid

  default_scope { order(position: :asc) }

  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
