class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    # ✅ id: :uuid でUUID型の主キーを指定
    create_table :recipes, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      # ✅ type: :uuid を指定してuser_idもUUID型にする
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :recipes, :name
    add_index :recipes, :created_at
  end
end