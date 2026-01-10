class AddForeignKeyToMenuRecipes < ActiveRecord::Migration[7.2]
  def change
    change_column_null :menu_recipes, :menu_id, false
    change_column_null :menu_recipes, :recipe_id, false
    
    add_index :menu_recipes, :menu_id unless index_exists?(:menu_recipes, :menu_id)
    add_index :menu_recipes, :recipe_id unless index_exists?(:menu_recipes, :recipe_id)
    
    add_foreign_key :menu_recipes, :menus, column: :menu_id, primary_key: :uuid unless foreign_key_exists?(:menu_recipes, :menus, column: :menu_id)
    add_foreign_key :menu_recipes, :recipes, column: :recipe_id, primary_key: :uuid unless foreign_key_exists?(:menu_recipes, :recipes, column: :recipe_id)
  end
end
