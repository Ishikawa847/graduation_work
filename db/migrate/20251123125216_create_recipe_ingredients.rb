class CreateRecipeIngredients < ActiveRecord::Migration[7.2]
  def change
    # ✅ 中間テーブルの主キーはUUID化する(推奨)
    create_table :recipe_ingredients, id: :uuid do |t|
      # ✅ recipe_idはUUID型にする(recipesテーブルがUUIDのため)
      t.references :recipe, null: false, foreign_key: true, type: :uuid
      # ✅ ingredient_idはbigint型のまま(ingredientsテーブルがbigintのため)
      t.references :ingredient, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
    
    add_index :recipe_ingredients, [ :recipe_id, :ingredient_id ], unique: true
  end
end