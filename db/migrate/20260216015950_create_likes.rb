class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :recipe, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :likes, [:user_id, :recipe_id], unique: true
  end
end
