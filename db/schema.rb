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

ActiveRecord::Schema.define(version: 20160324232302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "food_entries", force: :cascade do |t|
    t.text     "description",                       null: false
    t.integer  "calories",    limit: 8, default: 0, null: false
    t.integer  "fat"
    t.integer  "carbs"
    t.integer  "protein"
    t.integer  "day",                               null: false
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "food_entries", ["user_id", "day", "created_at"], name: "index_food_entries_on_user_id_and_day_and_created_at", using: :btree
  add_index "food_entries", ["user_id"], name: "index_food_entries_on_user_id", using: :btree

  create_table "foods", force: :cascade do |t|
    t.text     "name",                        null: false
    t.text     "description"
    t.text     "ndbno"
    t.text     "upc"
    t.integer  "popularity",  default: 0
    t.integer  "likes",       default: 0
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "deleted",     default: false
  end

  add_index "foods", ["name"], name: "index_foods_on_name", using: :btree
  add_index "foods", ["user_id"], name: "index_foods_on_user_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "measurement_id"
    t.text     "name"
    t.integer  "calories"
    t.integer  "fat"
    t.integer  "carbs"
    t.integer  "protein"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "amount"
  end

  create_table "measurements", force: :cascade do |t|
    t.text     "amount",                 null: false
    t.text     "unit",                   null: false
    t.integer  "calories",               null: false
    t.integer  "fat",                    null: false
    t.integer  "carbs",                  null: false
    t.integer  "protein",                null: false
    t.integer  "popularity", default: 0
    t.integer  "food_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "measurements", ["food_id"], name: "index_measurements_on_food_id", using: :btree

  create_table "recipes", force: :cascade do |t|
    t.text     "name",                     null: false
    t.text     "description"
    t.text     "instructions"
    t.integer  "user_id"
    t.integer  "popularity",   default: 0
    t.integer  "likes",        default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "servings",     default: 1
  end

  add_index "recipes", ["name"], name: "index_recipes_on_name", using: :btree
  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "role",            default: 0
    t.hstore   "preferences",     default: {"sex"=>"na"}, null: false
  end

  create_table "weight_entries", force: :cascade do |t|
    t.integer  "value"
    t.integer  "day"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "weight_entries", ["user_id"], name: "index_weight_entries_on_user_id", using: :btree

  add_foreign_key "food_entries", "users"
  add_foreign_key "foods", "users"
  add_foreign_key "measurements", "foods"
  add_foreign_key "recipes", "users"
  add_foreign_key "weight_entries", "users"
end
