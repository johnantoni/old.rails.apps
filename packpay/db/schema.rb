# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chats", :force => true do |t|
    t.string  "name"
    t.integer "subject"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "chat_id",    :null => false
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["user_id"], :name => "fk_c_users"
  add_index "comments", ["chat_id"], :name => "fk_c_chats"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "friend_id",   :null => false
    t.datetime "created_at"
    t.datetime "accepted_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.boolean  "default",      :default => false, :null => false
    t.integer  "parent_id"
    t.string   "content_type", :default => "",    :null => false
    t.string   "filename",     :default => "",    :null => false
    t.string   "thumbnail"
    t.integer  "size",                            :null => false
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["user_id"], :name => "fk_i_users"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id",                        :null => false
    t.integer  "receiver_id",                      :null => false
    t.string   "subject",          :default => "", :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "read_at"
    t.boolean  "sender_deleted"
    t.boolean  "receiver_deleted"
    t.boolean  "sender_purged"
    t.boolean  "receiver_purged"
  end

  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"
  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"

  create_table "profiles", :force => true do |t|
    t.integer "user_id",                         :null => false
    t.string  "firstname"
    t.string  "lastname"
    t.date    "dob"
    t.string  "gender",      :default => "Male"
    t.string  "about"
    t.string  "location"
    t.string  "postcode"
    t.string  "country"
    t.string  "tel_mobile"
    t.string  "tel_home"
    t.string  "tel_work"
    t.boolean "legal_terms"
  end

  create_table "signups", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "pw_reset_code"
  end

end
