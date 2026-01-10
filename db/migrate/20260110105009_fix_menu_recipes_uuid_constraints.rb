class FixMenuRecipesUuidConstraints < ActiveRecord::Migration[7.2]
  def up
    remove_foreign_key :recipe_ingredients, :recipes if foreign_key_exists?(:recipe_ingredients, :recipes)
    
    remove_index :recipe_ingredients, :recipe_id if index_exists?(:recipe_ingredients, :recipe_id)
    
    add_column :recipe_ingredients, :recipe_uuid, :uuid
    
    execute <<-SQL
      UPDATE recipe_ingredients
      SET recipe_uuid = recipes.uuid
      FROM recipes
      WHERE recipe_ingredients.recipe_id = recipes.id
    SQL
    
    remove_column :recipe_ingredients, :recipe_id
    rename_column :recipe_ingredients, :recipe_uuid, :recipe_id
    
    change_column_null :recipe_ingredients, :recipe_id, false
    
    add_foreign_key :recipe_ingredients, :recipes, column: :recipe_id, primary_key: :uuid
    add_index :recipe_ingredients, :recipe_id
  end

  def down
    remove_foreign_key :recipe_ingredients, :recipes if foreign_key_exists?(:recipe_ingredients, :recipes)
    remove_index :recipe_ingredients, :recipe_id if index_exists?(:recipe_ingredients, :recipe_id)
    
    rename_column :recipe_ingredients, :recipe_id, :recipe_uuid
    add_column :recipe_ingredients, :recipe_id, :bigint
    
    execute <<-SQL
      UPDATE recipe_ingredients
      SET recipe_id = recipes.id
      FROM recipes
      WHERE recipe_ingredients.recipe_uuid = recipes.uuid
    SQL
    
    remove_column :recipe_ingredients, :recipe_uuid
    change_column_null :recipe_ingredients, :recipe_id, false
    
    add_foreign_key :recipe_ingredients, :recipes, column: :recipe_id
    add_index :recipe_ingredients, :recipe_id
  end
end
