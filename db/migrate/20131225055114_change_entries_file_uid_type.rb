class ChangeEntriesFileUidType < ActiveRecord::Migration
  def up
    change_column :entries, :file_uid, :text
  end

  def down
    change_column :entries, :file_uid, :string
  end
end
