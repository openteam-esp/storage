class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string  :type
      t.string  :name
      t.string  :mime
      t.integer :size
      t.string  :uid
      t.string  :ancestry
      t.integer :ancestry_depth
      t.timestamps
    end
    add_index :entries, :name
    add_index :entries, :ancestry
  end
end
