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

ActiveRecord::Schema.define(version: 20160708170310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "name"
    t.text     "description"
    t.text     "exrx"
    t.integer  "activity_type",    limit: 2,  default: 0,                          null: false
    t.string   "muscle_groups",    limit: 24, default: "000000000000000000000000", null: false
    t.integer  "calories_formula", limit: 2
    t.integer  "popularity"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.boolean  "deleted",                     default: false,                      null: false
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "activity_entries", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.integer  "routine_id"
    t.integer  "day",         limit: 8
    t.integer  "reps"
    t.integer  "work"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.datetime "day_ts",                default: '2016-07-06 18:03:32', null: false
  end

  add_index "activity_entries", ["activity_id"], name: "index_activity_entries_on_activity_id", using: :btree
  add_index "activity_entries", ["routine_id"], name: "index_activity_entries_on_routine_id", using: :btree
  add_index "activity_entries", ["user_id"], name: "index_activity_entries_on_user_id", using: :btree

  create_table "food_entries", force: :cascade do |t|
    t.text     "description",                                           null: false
    t.integer  "calories",    limit: 8, default: 0,                     null: false
    t.integer  "fat"
    t.integer  "carbs"
    t.integer  "protein"
    t.integer  "day",                                                   null: false
    t.integer  "user_id"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.datetime "day_ts",                default: '2016-06-02 17:27:21', null: false
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

  create_table "pt_messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_type", limit: 2,                  null: false
    t.string   "uid",          limit: 32,                 null: false
    t.text     "message",                                 null: false
    t.boolean  "seen",                    default: false
    t.boolean  "deleted",                 default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "mood",         limit: 2,  default: 0
    t.text     "message_html"
    t.text     "subject"
  end

  add_index "pt_messages", ["user_id"], name: "index_pt_messages_on_user_id", using: :btree

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

  create_table "routine_completions", force: :cascade do |t|
    t.integer  "routine_id"
    t.integer  "user_id"
    t.integer  "day",        limit: 8
    t.text     "notes"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "routine_completions", ["routine_id"], name: "index_routine_completions_on_routine_id", using: :btree
  add_index "routine_completions", ["user_id"], name: "index_routine_completions_on_user_id", using: :btree

  create_table "routines", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "name"
    t.text     "description"
    t.integer  "last_completion", limit: 8
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "activities",                default: [],              array: true
  end

  add_index "routines", ["user_id"], name: "index_routines_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "day_ts",     default: '2016-06-02 17:27:21', null: false
  end

  add_index "weight_entries", ["user_id"], name: "index_weight_entries_on_user_id", using: :btree

  add_foreign_key "activities", "users"
  add_foreign_key "activity_entries", "activities"
  add_foreign_key "activity_entries", "routines"
  add_foreign_key "activity_entries", "users"
  add_foreign_key "food_entries", "users"
  add_foreign_key "foods", "users"
  add_foreign_key "measurements", "foods"
  add_foreign_key "pt_messages", "users"
  add_foreign_key "recipes", "users"
  add_foreign_key "routine_completions", "routines"
  add_foreign_key "routine_completions", "users"
  add_foreign_key "routines", "users"
  add_foreign_key "weight_entries", "users"
end
