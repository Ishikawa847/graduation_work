class AddIndexesToRecipes < ActiveRecord::Migration[7.2]
  def change
    # add_column :recipes, :name, :string, null: false
    # add_column :recipes, :description, :text, null: false
    # add_reference :recipes, :user, null: false, foreign_key: true

    # add_index :recipes, :name
    # add_index :recipes, :created_at
  end
end
