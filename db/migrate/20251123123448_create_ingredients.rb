class CreateIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.float :protein
      t.float :fat
      t.float :carb

      t.timestamps
    end
  end
end
