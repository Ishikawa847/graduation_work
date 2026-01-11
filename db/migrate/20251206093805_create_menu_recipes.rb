class CreateMenuRecipes < ActiveRecord::Migration[7.2]
  def change
    # ✅ 中間テーブルの主キーをUUID型にする
    create_table :menu_recipes, id: :uuid do |t|
      # ✅ menu_idをUUID型にする(menusテーブルがUUIDのため)
      t.references :menu, null: false, foreign_key: true, type: :uuid
      # ✅ recipe_idをUUID型にする(recipesテーブルがUUIDのため)
      t.references :recipe, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
