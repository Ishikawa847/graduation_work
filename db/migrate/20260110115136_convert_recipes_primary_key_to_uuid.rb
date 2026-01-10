class ConvertRecipesPrimaryKeyToUuid < ActiveRecord::Migration[7.2]
  def up
    remove_foreign_key :recipe_ingredients, :recipes if foreign_key_exists?(:recipe_ingredients, :recipes)
    remove_foreign_key :menu_recipes, :recipes if foreign_key_exists?(:menu_recipes, :recipes)
    
    execute "ALTER TABLE recipes DROP CONSTRAINT recipes_pkey CASCADE"
    
    execute "ALTER TABLE recipes ADD PRIMARY KEY (uuid)"
    
    remove_column :recipes, :id if column_exists?(:recipes, :id)
    
    add_foreign_key :recipe_ingredients, :recipes, column: :recipe_id, primary_key: :uuid
    
    add_foreign_key :menu_recipes, :recipes, column: :recipe_id, primary_key: :uuid
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
