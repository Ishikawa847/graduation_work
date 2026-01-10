class FixRecipeIngredientsUuidMigration < ActiveRecord::Migration[7.2]
  def up
    if foreign_key_exists?(:recipe_ingredients, :recipes)
      remove_foreign_key :recipe_ingredients, :recipes
    end
    
    if index_exists?(:recipe_ingredients, :recipe_id)
      remove_index :recipe_ingredients, :recipe_id
    end
    
    unless column_exists?(:recipe_ingredients, :recipe_uuid)
      add_column :recipe_ingredients, :recipe_uuid, :uuid
    end
    
    execute <<-SQL
      UPDATE recipe_ingredients
      SET recipe_uuid = recipes.uuid
      FROM recipes
      WHERE recipe_ingredients.recipe_id = recipes.uuid
    SQL
    
    if column_exists?(:recipe_ingredients, :recipe_id)
      remove_column :recipe_ingredients, :recipe_id
    end
    
    if column_exists?(:recipe_ingredients, :recipe_uuid)
      rename_column :recipe_ingredients, :recipe_uuid, :recipe_id
    end
    
    change_column_null :recipe_ingredients, :recipe_id, false
    
    unless foreign_key_exists?(:recipe_ingredients, :recipes, column: :recipe_id)
      add_foreign_key :recipe_ingredients, :recipes, column: :recipe_id, primary_key: :uuid
    end
    
    unless index_exists?(:recipe_ingredients, :recipe_id)
      add_index :recipe_ingredients, :recipe_id
    end
  end

  def down
    if foreign_key_exists?(:recipe_ingredients, :recipes)
      remove_foreign_key :recipe_ingredients, :recipes
    end
    
    if index_exists?(:recipe_ingredients, :recipe_id)
      remove_index :recipe_ingredients, :recipe_id
    end
    
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
