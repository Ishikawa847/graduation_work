class ConvertRecipesToUuid < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :recipes, :uuid, unique: true
  end
end
