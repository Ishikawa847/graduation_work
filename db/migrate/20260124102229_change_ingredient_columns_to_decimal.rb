class ChangeIngredientColumnsToDecimal < ActiveRecord::Migration[7.2]
  def up
    change_column :ingredients, :protein, :decimal, precision: 5, scale: 1
    change_column :ingredients, :fat, :decimal, precision: 5, scale: 1
    change_column :ingredients, :carb, :decimal, precision: 5, scale: 1
  end

  def down
    change_column :ingredients, :protein, :float
    change_column :ingredients, :fat, :float
    change_column :ingredients, :carb, :float
  end
end
