class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string  :type
      t.string  :name
      t.string  :ancestry
      t.integer :ancestry_depth
      t.string  :file_uid
      t.integer :file_size
      t.integer :file_width
      t.integer :file_height
      t.string  :file_mime_type
      t.string  :file_mime_directory
      t.timestamps
    end
    add_index :entries, :name
    add_index :entries, :ancestry
  end
end
