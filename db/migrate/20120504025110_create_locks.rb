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
  end
end
