class MigrateMenuRecipesToUuid < ActiveRecord::Migration[7.2]
  def up
    # menu_idをUUIDに変更
    add_column :menu_recipes, :menu_uuid, :uuid
    
    execute <<-SQL
      UPDATE menu_recipes
      SET menu_uuid = menus.uuid
      FROM menus
      WHERE menu_recipes.menu_id = menus.id
    SQL
    
    remove_column :menu_recipes, :menu_id
    add_index :menu_recipes, :menu_uuid
    rename_column :menu_recipes, :menu_uuid, :menu_id
    
    # recipe_idをUUIDに変更
    add_column :menu_recipes, :recipe_uuid, :uuid
    
    execute <<-SQL
      UPDATE menu_recipes
      SET recipe_uuid = recipes.uuid
      FROM recipes
      WHERE menu_recipes.recipe_id = recipes.id
    SQL
    
    remove_column :menu_recipes, :recipe_id
    add_index :menu_recipes, :recipe_uuid
    rename_column :menu_recipes, :recipe_uuid, :recipe_id
  end

  def down
    # recipe_idを戻す
    rename_column :menu_recipes, :recipe_id, :recipe_uuid
    add_column :menu_recipes, :recipe_id, :integer
    
    execute <<-SQL
      UPDATE menu_recipes
      SET recipe_id = recipes.id
      FROM recipes
      WHERE menu_recipes.recipe_uuid = recipes.uuid
    SQL
    
    remove_column :menu_recipes, :recipe_uuid
    
    # menu_idを戻す
    rename_column :menu_recipes, :menu_id, :menu_uuid
    add_column :menu_recipes, :menu_id, :integer
    
    execute <<-SQL
      UPDATE menu_recipes
      SET menu_id = menus.id
      FROM menus
      WHERE menu_recipes.menu_uuid = menus.uuid
    SQL
    
    remove_column :menu_recipes, :menu_uuid
  end

end
