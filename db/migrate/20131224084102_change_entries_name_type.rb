class ChangeEntriesNameType < ActiveRecord::Migration
  def up
    change_column :entries, :name, :text
  end

  def down
    change_column :entries, :name, :string
  end
end
