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

ActiveRecord::Schema.define(version: 20160207180145) do

  create_table "food_entries", force: :cascade do |t|
    t.string   "description"
    t.integer  "calories",    default: 0, null: false
    t.integer  "fat"
    t.integer  "carbs"
    t.integer  "protein"
    t.integer  "day",                     null: false
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "food_entries", ["user_id", "day", "created_at"], name: "index_food_entries_on_user_id_and_day_and_created_at"
  add_index "food_entries", ["user_id"], name: "index_food_entries_on_user_id"

  create_table "foods", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "food_type",    default: 0
    t.integer  "calories"
    t.integer  "fat"
    t.integer  "carbs"
    t.integer  "protein"
    t.integer  "amount"
    t.integer  "measurement"
    t.integer  "serving_size"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

end
