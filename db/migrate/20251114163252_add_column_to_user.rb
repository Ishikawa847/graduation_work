class AddColumnToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, null: false, limit: 100
    add_column :users, :height, :float
    add_column :users, :weight, :float
    add_column :users, :age, :integer
    add_column :users, :gender, :integer, default: 0
  end
end
