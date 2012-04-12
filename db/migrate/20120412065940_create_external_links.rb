class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.references :entry
      t.text :path
      t.text :url

      t.timestamps
    end
    add_index :external_links, :path
    add_index :external_links, :url
  end
end
