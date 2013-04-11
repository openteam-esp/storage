class AddUniqueEntryPathIndex < ActiveRecord::Migration
  def change
    add_index :entries, [:ancestry, :name], :unique => true
  end
end
