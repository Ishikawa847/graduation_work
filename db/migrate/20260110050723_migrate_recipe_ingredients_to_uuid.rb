class MigrateRecipeIngredientsToUuid < ActiveRecord::Migration[7.2]
  def up
    add_column :recipe_ingredients, :recipe_uuid, :uuid
    
    execute <<-SQL
      UPDATE recipe_ingredients
      SET recipe_uuid = recipes.uuid
      FROM recipes
      WHERE recipe_ingredients.recipe_id = recipes.id
    SQL
    
    remove_column :recipe_ingredients, :recipe_id
    add_index :recipe_ingredients, :recipe_uuid
    rename_column :recipe_ingredients, :recipe_uuid, :recipe_id
  end

  def down
    rename_column :recipe_ingredients, :recipe_id, :recipe_uuid
    add_column :recipe_ingredients, :recipe_id, :integer
    
    execute <<-SQL
      UPDATE recipe_ingredients
      SET recipe_id = recipes.id
      FROM recipes
      WHERE recipe_ingredients.recipe_uuid = recipes.uuid
    SQL
    
    remove_column :recipe_ingredients, :recipe_uuid
  end
end
