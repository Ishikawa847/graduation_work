class CreateDailyMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_menus, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :menu, null: false, foreign_key: true, type: :uuid
      t.date :date

      t.timestamps
    end

    add_index :daily_menus, [ :user_id, :date ], unique: true
  end
end
