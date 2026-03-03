class ChangeActiveStorageRecordIdToUuid < ActiveRecord::Migration[7.2]
  def up
    # 既存の record_id カラムを削除
    remove_column :active_storage_attachments, :record_id
    
    # 新しく UUID 型で record_id カラムを追加
    add_column :active_storage_attachments, :record_id, :uuid
    
    # Active Storage に必要なインデックスを再作成
    add_index :active_storage_attachments, [:record_type, :record_id, :name, :blob_id], 
              name: :index_active_storage_attachments_uniqueness, unique: true
  end

  def down
    remove_column :active_storage_attachments, :record_id
    add_column :active_storage_attachments, :record_id, :bigint, null: false
  end
end
