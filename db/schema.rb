# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131224084102) do

  create_table "entries", :force => true do |t|
    t.string   "type"
    t.text     "name"
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.string   "file_uid"
    t.integer  "file_size"
    t.integer  "file_width"
    t.integer  "file_height"
    t.string   "file_mime_type"
    t.string   "file_mime_directory"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "entries", ["ancestry", "name"], :name => "index_entries_on_ancestry_and_name", :unique => true
  add_index "entries", ["ancestry"], :name => "index_entries_on_ancestry"
  add_index "entries", ["name"], :name => "index_entries_on_name"

  create_table "locks", :force => true do |t|
    t.string   "type"
    t.integer  "entry_id"
    t.integer  "file_entry_id"
    t.string   "entry_path"
    t.string   "entry_url"
    t.string   "external_url"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "locks", ["entry_id"], :name => "index_locks_on_entry_id"
  add_index "locks", ["entry_path"], :name => "index_locks_on_entry_path"
  add_index "locks", ["entry_url"], :name => "index_locks_on_entry_url"
  add_index "locks", ["external_url"], :name => "index_locks_on_external_url"
  add_index "locks", ["file_entry_id"], :name => "index_locks_on_file_entry_id"
  add_index "locks", ["type"], :name => "index_locks_on_type"

end
