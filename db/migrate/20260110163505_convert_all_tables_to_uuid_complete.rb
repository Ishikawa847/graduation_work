class ConvertAllTablesToUuidComplete < ActiveRecord::Migration[7.2]
    # recipes テーブルの状態を確認
    check_recipes_table_status
    
    # ステップ1: recipe_ingredients の UUID 化
    convert_recipe_ingredients_to_uuid
    
    # ステップ2: menu_recipes の UUID 化
    convert_menu_recipes_to_uuid
    
    # ステップ3: 外部キー制約とインデックスを追加
    add_constraints_and_indexes
    
    say "✅ All tables successfully converted to UUID!", true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "このマイグレーションはロールバックできません"
  end

  private

  # ========================================
  # recipes テーブルの状態確認
  # ========================================
  def check_recipes_table_status
    say "Checking recipes table status..."
    
    # recipes テーブルの主キーの型を確認
    pk_column = connection.columns(:recipes).find { |c| c.name == 'id' }
    
    if pk_column.nil?
      # id カラムが存在しない場合、uuid カラムをチェック
      uuid_column = connection.columns(:recipes).find { |c| c.name == 'uuid' }
      
      if uuid_column && uuid_column.sql_type == 'uuid'
        say "✅ recipes table uses 'uuid' column as primary key", true
      else
        raise "recipes table structure is unexpected. Please check the schema."
      end
    elsif pk_column.sql_type == 'uuid'
      say "✅ recipes table uses 'id' column with UUID type", true
    else
      raise "recipes table 'id' column is not UUID type (#{pk_column.sql_type}). Please convert recipes table first."
    end
  end

  # ========================================
  # recipes テーブルの主キーカラム名を取得
  # ========================================
  def get_recipes_primary_key_column
    # recipes テーブルに 'id' カラムがあるか確認
    id_column = connection.columns(:recipes).find { |c| c.name == 'id' }
    
    if id_column && id_column.sql_type == 'uuid'
      return 'id'
    end
    
    # 'uuid' カラムがあるか確認
    uuid_column = connection.columns(:recipes).find { |c| c.name == 'uuid' }
    
    if uuid_column && uuid_column.sql_type == 'uuid'
      return 'uuid'
    end
    
    raise "recipes table does not have a UUID primary key column"
  end

  # ========================================
  # recipe_ingredients の UUID 化
  # ========================================
  def convert_recipe_ingredients_to_uuid
    say "Converting recipe_ingredients.recipe_id to UUID..."
    
    # recipe_id カラムの現在の型を確認
    column = connection.columns(:recipe_ingredients).find { |c| c.name == 'recipe_id' }
    
    if column.sql_type == 'uuid'
      say "✅ recipe_ingredients.recipe_id is already UUID type. Skipping...", true
      return
    end
    
    # 外部キー制約を削除（存在する場合）
    if foreign_key_exists?(:recipe_ingredients, :recipes, column: :recipe_id)
      say "Removing foreign key constraint...", true
      remove_foreign_key :recipe_ingredients, :recipes, column: :recipe_id
    end
    
    # インデックスを削除（存在する場合）
    if index_exists?(:recipe_ingredients, :recipe_id)
      say "Removing index...", true
      remove_index :recipe_ingredients, :recipe_id
    end
    
    # recipe_uuid カラムが既に存在する場合は削除
    if column_exists?(:recipe_ingredients, :recipe_uuid)
      say "⚠️ recipe_uuid column already exists. Removing it first...", true
      remove_column :recipe_ingredients, :recipe_uuid
    end
    
    # 新しいUUIDカラムを追加
    say "Adding recipe_uuid column...", true
    add_column :recipe_ingredients, :recipe_uuid, :uuid
    
    # recipes テーブルの主キーカラム名を取得
    recipes_pk_column = get_recipes_primary_key_column
    
    # データを移行（NULL チェックを追加）
    say "Migrating data from recipe_id to recipe_uuid...", true
    execute(<<-SQL.squish)
      UPDATE recipe_ingredients ri
      SET recipe_uuid = r.#{recipes_pk_column}
      FROM recipes r
      WHERE ri.recipe_id IS NOT NULL
        AND r.#{recipes_pk_column} IS NOT NULL
        AND ri.recipe_id::text = r.#{recipes_pk_column}::text
    SQL
    
    # 移行できなかったレコードを確認
    null_count = execute(
      "SELECT COUNT(*) FROM recipe_ingredients WHERE recipe_uuid IS NULL AND recipe_id IS NOT NULL"
    ).first['count'].to_i
    
    if null_count > 0
      say "⚠️ Warning: #{null_count} recipe_ingredients records could not be migrated", true
      say "⚠️ These records will be deleted to maintain data integrity", true
      execute("DELETE FROM recipe_ingredients WHERE recipe_uuid IS NULL AND recipe_id IS NOT NULL")
    end
    
    # 古いカラムを削除
    say "Removing old recipe_id column...", true
    remove_column :recipe_ingredients, :recipe_id
    
    # カラム名を変更
    say "Renaming recipe_uuid to recipe_id...", true
    rename_column :recipe_ingredients, :recipe_uuid, :recipe_id
    
    # NOT NULL 制約を追加
    say "Adding NOT NULL constraint...", true
    change_column_null :recipe_ingredients, :recipe_id, false
    
    say "✅ recipe_ingredients.recipe_id converted to UUID", true
  end

  # ========================================
  # menu_recipes の UUID 化
  # ========================================
  def convert_menu_recipes_to_uuid
    say "Converting menu_recipes columns to UUID..."
    
    convert_menu_recipes_menu_id
    convert_menu_recipes_recipe_id
    
    say "✅ menu_recipes columns converted to UUID", true
  end
  # ========================================
  # menu_recipes.menu_id の UUID 化
  # ========================================
  def convert_menu_recipes_menu_id
    say "Converting menu_recipes.menu_id to UUID..."
    
    # menu_id カラムの現在の型を確認
    column = connection.columns(:menu_recipes).find { |c| c.name == 'menu_id' }
    
    if column.sql_type == 'uuid'
      say "✅ menu_recipes.menu_id is already UUID type. Skipping...", true
      return
    end
    
    # 外部キー制約を削除（存在する場合）
    if foreign_key_exists?(:menu_recipes, :menus, column: :menu_id)
      say "Removing foreign key constraint...", true
      remove_foreign_key :menu_recipes, :menus, column: :menu_id
    end
    
    # インデックスを削除（存在する場合）
    if index_exists?(:menu_recipes, :menu_id)
      say "Removing index...", true
      remove_index :menu_recipes, :menu_id
    end
    
    # menu_uuid カラムが既に存在する場合は削除
    if column_exists?(:menu_recipes, :menu_uuid)
      say "⚠️ menu_uuid column already exists. Removing it first...", true
      remove_column :menu_recipes, :menu_uuid
    end
    
    # 新しいUUIDカラムを追加
    say "Adding menu_uuid column...", true
    add_column :menu_recipes, :menu_uuid, :uuid
    
    # menus テーブルの主キーカラム名を取得
    menus_pk = connection.primary_key(:menus)
    
    # データを移行（NULL チェックを追加）
    say "Migrating data from menu_id to menu_uuid...", true
    execute(<<-SQL.squish)
      UPDATE menu_recipes mr
      SET menu_uuid = m.#{menus_pk}
      FROM menus m
      WHERE mr.menu_id IS NOT NULL
        AND m.#{menus_pk} IS NOT NULL
        AND mr.menu_id::text = m.#{menus_pk}::text
    SQL
    
    # 移行できなかったレコードを確認
    null_count = execute(
      "SELECT COUNT(*) FROM menu_recipes WHERE menu_uuid IS NULL AND menu_id IS NOT NULL"
    ).first['count'].to_i
    
    if null_count > 0
      say "⚠️ Warning: #{null_count} menu_recipes records could not be migrated", true
      say "⚠️ These records will be deleted to maintain data integrity", true
      execute("DELETE FROM menu_recipes WHERE menu_uuid IS NULL AND menu_id IS NOT NULL")
    end
    
    # 古いカラムを削除
    say "Removing old menu_id column...", true
    remove_column :menu_recipes, :menu_id
    
    # カラム名を変更
    say "Renaming menu_uuid to menu_id...", true
    rename_column :menu_recipes, :menu_uuid, :menu_id
    
    # NOT NULL 制約を追加
    say "Adding NOT NULL constraint...", true
    change_column_null :menu_recipes, :menu_id, false
    
    say "✅ menu_recipes.menu_id converted to UUID", true
  end

  # ========================================
  # menu_recipes.recipe_id の UUID 化
  # ========================================
  def convert_menu_recipes_recipe_id
    say "Converting menu_recipes.recipe_id to UUID..."
    
    # recipe_id カラムの現在の型を確認
    column = connection.columns(:menu_recipes).find { |c| c.name == 'recipe_id' }
    
    if column.sql_type == 'uuid'
      say "✅ menu_recipes.recipe_id is already UUID type. Skipping...", true
      return
    end
    
    # 外部キー制約を削除（存在する場合）
    if foreign_key_exists?(:menu_recipes, :recipes, column: :recipe_id)
      say "Removing foreign key constraint...", true
      remove_foreign_key :menu_recipes, :recipes, column: :recipe_id
    end
    
    # インデックスを削除（存在する場合）
    if index_exists?(:menu_recipes, :recipe_id)
      say "Removing index...", true
      remove_index :menu_recipes, :recipe_id
    end
    
    # recipe_uuid カラムが既に存在する場合は削除
    if column_exists?(:menu_recipes, :recipe_uuid)
      say "⚠️ recipe_uuid column already exists. Removing it first...", true
      remove_column :menu_recipes, :recipe_uuid
    end
    
    # 新しいUUIDカラムを追加
    say "Adding recipe_uuid column...", true
    add_column :menu_recipes, :recipe_uuid, :uuid
    
    # recipes テーブルの主キーカラム名を取得
    recipes_pk_column = get_recipes_primary_key_column
    
    # データを移行（NULL チェックを追加）
    say "Migrating data from recipe_id to recipe_uuid...", true
    execute(<<-SQL.squish)
      UPDATE menu_recipes mr
      SET recipe_uuid = r.#{recipes_pk_column}
      FROM recipes r
      WHERE mr.recipe_id IS NOT NULL
        AND r.#{recipes_pk_column} IS NOT NULL
        AND mr.recipe_id::text = r.#{recipes_pk_column}::text
    SQL
    
    # 移行できなかったレコードを確認
    null_count = execute(
      "SELECT COUNT(*) FROM menu_recipes WHERE recipe_uuid IS NULL AND recipe_id IS NOT NULL"
    ).first['count'].to_i
    
    if null_count > 0
      say "⚠️ Warning: #{null_count} menu_recipes records could not be migrated", true
      say "⚠️ These records will be deleted to maintain data integrity", true
      execute("DELETE FROM menu_recipes WHERE recipe_uuid IS NULL AND recipe_id IS NOT NULL")
    end
    
    # 古いカラムを削除
    say "Removing old recipe_id column...", true
    remove_column :menu_recipes, :recipe_id
    
    # カラム名を変更
    say "Renaming recipe_uuid to recipe_id...", true
    rename_column :menu_recipes, :recipe_uuid, :recipe_id
    
    # NOT NULL 制約を追加
    say "Adding NOT NULL constraint...", true
    change_column_null :menu_recipes, :recipe_id, false
    
    say "✅ menu_recipes.recipe_id converted to UUID", true
  end
  # ========================================
  # 外部キー制約とインデックスを追加
  # ========================================
  def add_constraints_and_indexes
    say "Adding foreign key constraints and indexes..."
    
    # recipes テーブルの主キーカラム名を取得
    recipes_pk_column = get_recipes_primary_key_column
    
    # recipe_ingredients の外部キー制約とインデックス
    unless foreign_key_exists?(:recipe_ingredients, :recipes, column: :recipe_id)
      say "Adding foreign key: recipe_ingredients.recipe_id -> recipes.#{recipes_pk_column}", true
      add_foreign_key :recipe_ingredients, :recipes, 
                      column: :recipe_id, 
                      primary_key: recipes_pk_column
    end
    
    unless index_exists?(:recipe_ingredients, :recipe_id)
      say "Adding index on recipe_ingredients.recipe_id", true
      add_index :recipe_ingredients, :recipe_id
    end
    
    # menu_recipes の外部キー制約とインデックス (menu_id)
    menus_pk = connection.primary_key(:menus)
    
    unless foreign_key_exists?(:menu_recipes, :menus, column: :menu_id)
      say "Adding foreign key: menu_recipes.menu_id -> menus.#{menus_pk}", true
      add_foreign_key :menu_recipes, :menus, 
                      column: :menu_id, 
                      primary_key: menus_pk
    end
    
    unless index_exists?(:menu_recipes, :menu_id)
      say "Adding index on menu_recipes.menu_id", true
      add_index :menu_recipes, :menu_id
    end
    
    # menu_recipes の外部キー制約とインデックス (recipe_id)
    unless foreign_key_exists?(:menu_recipes, :recipes, column: :recipe_id)
      say "Adding foreign key: menu_recipes.recipe_id -> recipes.#{recipes_pk_column}", true
      add_foreign_key :menu_recipes, :recipes, 
                      column: :recipe_id, 
                      primary_key: recipes_pk_column
    end
    
    unless index_exists?(:menu_recipes, :recipe_id)
      say "Adding index on menu_recipes.recipe_id", true
      add_index :menu_recipes, :recipe_id
    end
    
    say "✅ Foreign key constraints and indexes added", true
  end
end
