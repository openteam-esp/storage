class CreateLocks < ActiveRecord::Migration
  def change
    create_table :locks do |t|
      t.string :type
      t.references :entry
      t.references :file_entry
      t.string :entry_path
      t.string :entry_url
      t.string :external_url
      t.timestamps
    end
    add_index :locks, :type
    add_index :locks, :entry_id
    add_index :locks, :file_entry_id
    add_index :locks, :entry_path
    add_index :locks, :entry_url
    add_index :locks, :external_url
  end
end
