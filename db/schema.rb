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

ActiveRecord::Schema.define(:version => 20130808124508) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "feedbacks", ["email"], :name => "index_feedbacks_on_email"

  create_table "ingredients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ingredients", ["name"], :name => "index_ingredients_on_name", :unique => true

  create_table "portions", :force => true do |t|
    t.string   "portion"
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "note"
    t.string   "part"
  end

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "calories"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "source_id"
    t.integer  "category_id"
    t.text     "note"
    t.boolean  "shareable",       :default => false
    t.string   "pax"
    t.string   "prep_time"
    t.string   "difficult_level"
    t.string   "page"
  end

  add_index "recipes", ["category_id"], :name => "index_recipes_on_category_id"
  add_index "recipes", ["shareable"], :name => "index_recipes_on_shareable"
  add_index "recipes", ["source_id"], :name => "index_recipes_on_source_id"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.date     "publish_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.boolean  "public"
    t.string   "image"
  end

  add_index "sources", ["public"], :name => "index_sources_on_public"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "usersbooks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "source_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "usersbooks", ["user_id"], :name => "index_usersbooks_on_user_id"

  create_table "usersmarks", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.integer  "mark_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "note"
  end

  add_index "usersmarks", ["user_id"], :name => "index_usersmarks_on_user_id"

end
