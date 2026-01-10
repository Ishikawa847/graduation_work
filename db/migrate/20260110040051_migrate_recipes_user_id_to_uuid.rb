class MigrateRecipesUserIdToUuid < ActiveRecord::Migration[7.2]
  def up
    add_column :recipes, :user_uuid, :uuid
    
    execute <<-SQL
      UPDATE recipes
      SET user_uuid = users.uuid
      FROM users
      WHERE recipes.user_id = users.id
    SQL
    
    add_index :recipes, :user_uuid
    
    remove_foreign_key :recipes, :users if foreign_key_exists?(:recipes, :users)
    
    remove_column :recipes, :user_id
    
    rename_column :recipes, :user_uuid, :user_id
    
    # add_foreign_key :recipes, :users, column: :user_id, primary_key: :uuid
  end

  def down
    rename_column :recipes, :user_id, :user_uuid
    
    add_column :recipes, :user_id, :integer
    
    execute <<-SQL
      UPDATE recipes
      SET user_id = users.id
      FROM users
      WHERE recipes.user_uuid = users.uuid
    SQL
    
    add_index :recipes, :user_id
    remove_column :recipes, :user_uuid
    
    add_foreign_key :recipes, :users
  end
end
