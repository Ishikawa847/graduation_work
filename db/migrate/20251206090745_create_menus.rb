class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    # ✅ テーブルの主キーをUUID型にする
    create_table :menus, id: :uuid do |t|
      # ✅ user_idをUUID型にする(usersテーブルがUUIDのため)
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false

      t.timestamps
    end
  end
end