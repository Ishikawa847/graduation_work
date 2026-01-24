class AddCaloriesToIngredients < ActiveRecord::Migration[7.2]
  def change
    add_column :ingredients, :calories, :decimal, precision: 5, scale: 1
  end
end
