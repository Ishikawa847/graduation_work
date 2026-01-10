class ConvertRecipesToUuid < ActiveRecord::Migration[7.2]
  def up
    # 既に uuid カラムが存在する場合はスキップ
    unless column_exists?(:recipes, :uuid)
      add_column :recipes, :uuid, :uuid, default: 'gen_random_uuid()', null: false
      add_index :recipes, :uuid, unique: true
    end
    
    # 外部キー制約を削除
    remove_foreign_keys_from_recipes
    
    # 古い id カラムを削除
    remove_column :recipes, :id
    
    # uuid カラムを id にリネーム
    rename_column :recipes, :uuid, :id
    
    # id を主キーに設定
    execute "ALTER TABLE recipes ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "このマイグレーションはロールバックできません"
  end

  private

  def remove_foreign_keys_from_recipes
    # recipe_ingredients からの外部キーを削除（存在する場合）
    if foreign_key_exists?(:recipe_ingredients, :recipes)
      remove_foreign_key :recipe_ingredients, :recipes
    end
    
    # menu_recipes からの外部キーを削除（存在する場合）
    if foreign_key_exists?(:menu_recipes, :recipes)
      remove_foreign_key :menu_recipes, :recipes
    end
  end
end
