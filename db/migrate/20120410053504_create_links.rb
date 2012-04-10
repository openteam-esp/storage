class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :storage_file_id
      t.references :linkable, :polymorphic => true
      t.timestamps
    end

    add_index :links, :storage_file_id
    add_index :links, [:linkable_id, :linkable_type]
  end
end
