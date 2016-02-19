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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160217180630) do

  create_table "food_entries", force: :cascade do |t|
    t.text     "description",                       null: false
    t.integer  "calories",    limit: 5, default: 0, null: false
    t.integer  "fat",         limit: 3
    t.integer  "carbs",       limit: 3
    t.integer  "protein",     limit: 3
    t.integer  "day",                               null: false
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "food_entries", ["user_id", "day", "created_at"], name: "index_food_entries_on_user_id_and_day_and_created_at"
  add_index "food_entries", ["user_id"], name: "index_food_entries_on_user_id"

  create_table "foods", force: :cascade do |t|
    t.text     "name",        limit: 255,             null: false
    t.text     "description"
    t.text     "ndbno",       limit: 8
    t.text     "upc",         limit: 12
    t.integer  "popularity",              default: 0
    t.integer  "likes",                   default: 0
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "foods", ["name"], name: "index_foods_on_name"
  add_index "foods", ["user_id"], name: "index_foods_on_user_id"

  create_table "measurements", force: :cascade do |t|
    t.text     "amount",     limit: 5,              null: false
    t.text     "unit",       limit: 96,             null: false
    t.integer  "calories",                          null: false
    t.integer  "fat",                               null: false
    t.integer  "carbs",                             null: false
    t.integer  "protein",                           null: false
    t.integer  "popularity",            default: 0
    t.integer  "food_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "measurements", ["food_id"], name: "index_measurements_on_food_id"

  create_table "option_values", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "option_id"
    t.text     "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "option_values", ["option_id"], name: "index_option_values_on_option_id"
  add_index "option_values", ["user_id"], name: "index_option_values_on_user_id"

  create_table "options", force: :cascade do |t|
    t.string   "name",          limit: 32
    t.string   "kind",          limit: 1,  default: "s"
    t.text     "values"
    t.text     "default_value"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "role",            default: 0
  end

end
