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

ActiveRecord::Schema[8.0].define(version: 2025_02_25_811919) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "api_calls", force: :cascade do |t|
    t.string "url"
    t.string "summary"
    t.json "response"
    t.json "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["summary"], name: "index_api_calls_on_summary"
    t.index ["url"], name: "index_api_calls_on_url"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.string "address"
    t.string "sleeper_id"
    t.integer "commissioner_id"
    t.string "sleeper_avatar_id"
    t.decimal "dues_ucsd"
    t.json "invites"
    t.json "seasons"
    t.json "users_payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_leagues_on_address"
    t.index ["commissioner_id"], name: "index_leagues_on_commissioner_id"
    t.index ["dues_ucsd"], name: "index_leagues_on_dues_ucsd"
    t.index ["sleeper_avatar_id"], name: "index_leagues_on_sleeper_avatar_id"
    t.index ["sleeper_id"], name: "index_leagues_on_sleeper_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.decimal "amount_ucsd"
    t.string "name"
    t.integer "user_id"
    t.integer "league_id"
    t.string "season"
    t.string "nft_image"
    t.json "nft_image_history"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amount_ucsd"], name: "index_rewards_on_amount_ucsd"
    t.index ["league_id"], name: "index_rewards_on_league_id"
    t.index ["name"], name: "index_rewards_on_name"
    t.index ["season"], name: "index_rewards_on_season"
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.decimal "dues_ucsd"
    t.string "season"
    t.string "team_name"
    t.string "team_avatar"
    t.integer "user_id"
    t.integer "league_id"
    t.boolean "is_commissioner"
    t.boolean "is_owner"
    t.boolean "is_bot"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dues_ucsd"], name: "index_seasons_on_dues_ucsd"
    t.index ["is_bot"], name: "index_seasons_on_is_bot"
    t.index ["is_commissioner"], name: "index_seasons_on_is_commissioner"
    t.index ["is_owner"], name: "index_seasons_on_is_owner"
    t.index ["league_id"], name: "index_seasons_on_league_id"
    t.index ["season"], name: "index_seasons_on_season"
    t.index ["team_avatar"], name: "index_seasons_on_team_avatar"
    t.index ["team_name"], name: "index_seasons_on_team_name"
    t.index ["user_id"], name: "index_seasons_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "key"
    t.string "session_id"
    t.string "username"
    t.integer "user_id"
    t.integer "league_id"
    t.string "email"
    t.string "wallet"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_sessions_on_email"
    t.index ["league_id"], name: "index_sessions_on_league_id"
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
    t.index ["username"], name: "index_sessions_on_username"
    t.index ["wallet"], name: "index_sessions_on_wallet"
  end

  create_table "users", force: :cascade do |t|
    t.string "import"
    t.string "username"
    t.string "email"
    t.string "avatar"
    t.string "wallet"
    t.string "sleeper_id"
    t.string "sleeper_avatar_id"
    t.json "seasons"
    t.json "favorite_league"
    t.json "leagues_cache"
    t.json "data"
    t.string "email_token"
    t.datetime "email_verification_sent_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["email_token"], name: "index_users_on_email_token"
    t.index ["import"], name: "index_users_on_import"
    t.index ["sleeper_avatar_id"], name: "index_users_on_sleeper_avatar_id"
    t.index ["sleeper_id"], name: "index_users_on_sleeper_id"
    t.index ["username"], name: "index_users_on_username"
    t.index ["wallet"], name: "index_users_on_wallet"
  end
end
