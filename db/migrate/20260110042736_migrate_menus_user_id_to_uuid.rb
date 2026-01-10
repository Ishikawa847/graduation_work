class MigrateMenusUserIdToUuid < ActiveRecord::Migration[7.2]
  def up
    add_column :menus, :user_uuid, :uuid
    
    execute <<-SQL
      UPDATE menus
      SET user_uuid = users.uuid
      FROM users
      WHERE menus.user_id = users.id
    SQL
    
    add_index :menus, :user_uuid
    remove_foreign_key :menus, :users if foreign_key_exists?(:menus, :users)
    remove_column :menus, :user_id
    rename_column :menus, :user_uuid, :user_id
  end

  def down
    rename_column :menus, :user_id, :user_uuid
    add_column :menus, :user_id, :integer
    
    execute <<-SQL
      UPDATE menus
      SET user_id = users.id
      FROM users
      WHERE menus.user_uuid = users.uuid
    SQL
    
    add_index :menus, :user_id
    remove_column :menus, :user_uuid
    add_foreign_key :menus, :users
  end
end
