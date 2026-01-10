class ConvertMenusToUuid < ActiveRecord::Migration[7.2]
  def up
    # 既に uuid カラムが存在する場合はスキップ
    unless column_exists?(:menus, :uuid)
      add_column :menus, :uuid, :uuid, default: 'gen_random_uuid()', null: false
      add_index :menus, :uuid, unique: true
    end
    
    # 外部キー制約を削除
    remove_foreign_keys_from_menus
    
    # 古い id カラムを削除
    remove_column :menus, :id
    
    # uuid カラムを id にリネーム
    rename_column :menus, :uuid, :id
    
    # id を主キーに設定
    execute "ALTER TABLE menus ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "このマイグレーションはロールバックできません"
  end

  private

  def remove_foreign_keys_from_menus
    # menu_recipes からの外部キーを削除(存在する場合)
    if foreign_key_exists?(:menu_recipes, :menus)
      remove_foreign_key :menu_recipes, :menus
    end
  end
end
