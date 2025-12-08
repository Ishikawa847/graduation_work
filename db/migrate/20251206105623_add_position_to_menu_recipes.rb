class AddPositionToMenuRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :menu_recipes, :position, :integer
    add_index :menu_recipes, [:menu_id, :position]
  end
end
