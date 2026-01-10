class ConvertAllTablesToUuidComplete < ActiveRecord::Migration[7.2]
  def up
    # recipesテーブルが既にUUID化されているかチェック
    recipes_pk = ActiveRecord::Base.connection.primary_key(:recipes)
    
    if recipes_pk == 'uuid'
      say "✅ recipes table is already using UUID as primary key. Skipping...", true
    else
      say "⚠️ recipes table is using '#{recipes_pk}' as primary key. Migration needed.", true
      # ここに recipes テーブルの UUID 化処理を追加（必要な場合）
    end
    
    # ステップ1: recipe_ingredients の UUID 化
    convert_recipe_ingredients_to_uuid
    
    # ステップ2: menu_recipes の UUID 化
    convert_menu_recipes_to_uuid
    
    # ステップ3: 外部キー制約とインデックスを追加
    add_constraints_and_indexes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  # ========================================
  # recipe_ingredients の UUID 化
  # ========================================
  def convert_recipe_ingredients_to_uuid
    say "Converting recipe_ingredients.recipe_id to UUID..."
    
    # recipe_idカラムが既にUUID型かチェック
    column = connection.columns(:recipe_ingredients).find { |c| c.name == 'recipe_id' }
    
    if column.sql_type == 'uuid'
      say "✅ recipe_ingredients.recipe_id is already UUID type. Skipping...", true
      return
    end
    
    # 外部キー制約を削除（存在する場合）
    if foreign_key_exists?(:recipe_ingredients, :recipes, column: :recipe_id)
      remove_foreign_key :recipe_ingredients, :recipes, column: :recipe_id
    end
    
    # インデックスを削除（存在する場合）
    if index_exists?(:recipe_ingredients, :recipe_id)
      remove_index :recipe_ingredients, :recipe_id
    end
    
    # 新しいUUIDカラムを追加
    unless column_exists?(:recipe_ingredients, :recipe_uuid)
      add_column :recipe_ingredients, :recipe_uuid, :uuid
    end
    
    # recipesテーブルの主キーカラム名を取得
    recipes_pk = connection.primary_key(:recipes)
    
    # データを移行
    execute(<<-SQL.squish)
      UPDATE recipe_ingredients ri
      SET recipe_uuid = r.#{recipes_pk}
      FROM recipes r
      WHERE CAST(ri.recipe_id AS text) = CAST(r.#{recipes_pk} AS text)
    SQL
    
    # NULL チェック
    null_count = execute(
      "SELECT COUNT(*) FROM recipe_ingredients WHERE recipe_uuid IS NULL"
    ).first['count'].to_i
    
    if null_count > 0
      raise "Data migration failed: #{null_count} recipe_ingredients records have NULL recipe_uuid"
    end
    
    # 古いカラムを削除
    if column_exists?(:recipe_ingredients, :recipe_id)
      remove_column :recipe_ingredients, :recipe_id
    end
    
    # カラム名を変更
    if column_exists?(:recipe_ingredients, :recipe_uuid)
      rename_column :recipe_ingredients, :recipe_uuid, :recipe_id
    end
    
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

  def convert_menu_recipes_menu_id
    # menu_idカラムが既にUUID型かチェック
    column = connection.columns(:menu_recipes).find { |c| c.name == 'menu_id' }
    
    if column.sql_type == 'uuid'
      say "✅ menu_recipes.menu_id is already UUID type. Skipping...", true
      return
    end
    
    # 外部キー制約を削除
    if foreign_key_exists?(:menu_recipes, :menus, column: :menu_id)
      remove_foreign_key :menu_recipes, :menus, column: :menu_id
    end
    
    # インデックスを削除
    if index_exists?(:menu_recipes, :menu_id)
      remove_index :menu_recipes, :menu_id
    end
    
    # 新しいUUIDカラムを追加
    unless column_exists?(:menu_recipes, :menu_uuid)
      add_column :menu_recipes, :menu_uuid, :uuid
    end
    
    # menusテーブルの主キーカラム名を取得
    menus_pk = connection.primary_key(:menus)
    
    # データを移行
    execute(<<-SQL.squish)
      UPDATE menu_recipes mr
      SET menu_uuid = m.#{menus_pk}
      FROM menus m
      WHERE CAST(mr.menu_id AS text) = CAST(m.#{menus_pk} AS text)
    SQL
    
    # NULL チェック
    null_count = execute(
      "SELECT COUNT(*) FROM menu_recipes WHERE menu_uuid IS NULL"
    ).first['count'].to_i
    
    if null_count > 0
      raise "Data migration failed: #{null_count} menu_recipes records have NULL menu_uuid"
    end
    
    # 古いカラムを削除してリネーム
    if column_exists?(:menu_recipes, :menu_id)
      remove_column :menu_recipes, :menu_id
    end
    
    if column_exists?(:menu_recipes, :menu_uuid)
      rename_column :menu_recipes, :menu_uuid, :menu_id
    end
  end
  def convert_menu_recipes_recipe_id
    # recipe_idカラムが既にUUID型かチェック
    column = connection.columns(:menu_recipes).find { |c| c.name == 'recipe_id' }
    
    if column.sql_type == 'uuid'
      say "✅ menu_recipes.recipe_id is already UUID type. Skipping...", true
      return
    end
    
    # 外部キー制約を削除
    if foreign_key_exists?(:menu_recipes, :recipes, column: :recipe_id)
      remove_foreign_key :menu_recipes, :recipes, column: :recipe_id
    end
    
    # インデックスを削除
    if index_exists?(:menu_recipes, :recipe_id)
      remove_index :menu_recipes, :recipe_id
    end
    
    # 新しいUUIDカラムを追加
    unless column_exists?(:menu_recipes, :recipe_uuid)
      add_column :menu_recipes, :recipe_uuid, :uuid
    end
    
    # recipesテーブルの主キーカラム名を取得
    recipes_pk = connection.primary_key(:recipes)
    
    # データを移行
    execute(<<-SQL.squish)
      UPDATE menu_recipes mr
      SET recipe_uuid = r.#{recipes_pk}
      FROM recipes r
      WHERE CAST(mr.recipe_id AS text) = CAST(r.#{recipes_pk} AS text)
    SQL
    
    # NULL チェック
    null_count = execute(
      "SELECT COUNT(*) FROM menu_recipes WHERE recipe_uuid IS NULL"
    ).first['count'].to_i
    
    if null_count > 0
      raise "Data migration failed: #{null_count} menu_recipes records have NULL recipe_uuid"
    end
    
    # 古いカラムを削除してリネーム
    if column_exists?(:menu_recipes, :recipe_id)
      remove_column :menu_recipes, :recipe_id
    end
    
    if column_exists?(:menu_recipes, :recipe_uuid)
      rename_column :menu_recipes, :recipe_uuid, :recipe_id
    end
  end

  # ========================================
  # 外部キー制約とインデックスを追加
  # ========================================
  def add_constraints_and_indexes
    say "Adding foreign key constraints and indexes..."
    
    # recipe_ingredients の外部キー制約とインデックス
    unless foreign_key_exists?(:recipe_ingredients, :recipes, column: :recipe_id)
      add_foreign_key :recipe_ingredients, :recipes, column: :recipe_id, primary_key: :uuid
    end
    
    unless index_exists?(:recipe_ingredients, :recipe_id)
      add_index :recipe_ingredients, :recipe_id
    end
    
    # menu_recipes の外部キー制約とインデックス
    unless foreign_key_exists?(:menu_recipes, :menus, column: :menu_id)
      # menusテーブルの主キーカラム名を取得
      menus_pk = connection.primary_key(:menus)
      add_foreign_key :menu_recipes, :menus, column: :menu_id, primary_key: menus_pk
    end
    
    unless index_exists?(:menu_recipes, :menu_id)
      add_index :menu_recipes, :menu_id
    end
    
    unless foreign_key_exists?(:menu_recipes, :recipes, column: :recipe_id)
      add_foreign_key :menu_recipes, :recipes, column: :recipe_id, primary_key: :uuid
    end
    
    unless index_exists?(:menu_recipes, :recipe_id)
      add_index :menu_recipes, :recipe_id
    end
    
    say "✅ Foreign key constraints and indexes added", true
  end
end
