# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_24_211918) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "leagues", force: :cascade do |t|
    t.string "address"
    t.string "name"
    t.string "avatar"
    t.integer "commissioner_id"
    t.json "invites"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "key"
    t.string "session_id"
    t.string "username"
    t.string "email"
    t.string "wallet"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "import"
    t.string "username"
    t.string "email"
    t.string "avatar"
    t.string "wallet"
    t.string "sleeper_id"
    t.string "sleeper_avatar_id"
    t.json "favorite_league"
    t.json "leagues_cache"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
