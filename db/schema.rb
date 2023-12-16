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

ActiveRecord::Schema[7.1].define(version: 2023_12_16_135936) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "target_table", null: false
    t.string "target_column", null: false
    t.string "target_value", null: false
    t.string "target_operator", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_groups_on_deleted_at"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
    t.index ["target_table", "target_column", "deleted_at"], name: "index_groups_on_target_table_and_target_column_and_deleted_at"
    t.index ["target_table", "target_column", "target_value", "target_operator"], name: "idx_on_target_table_target_column_target_value_targ_739aeb06e8", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_offers_on_deleted_at"
    t.index ["slug"], name: "index_offers_on_slug", unique: true
  end

  create_table "offers_groups", id: false, force: :cascade do |t|
    t.bigint "offer_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_offers_groups_on_group_id"
    t.index ["offer_id"], name: "index_offers_groups_on_offer_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "slug", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "gender", null: false
    t.string "birthdate", null: false
    t.integer "age", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["username", "deleted_at"], name: "index_users_on_username_and_deleted_at"
  end

  create_table "users_groups", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_users_groups_on_group_id"
    t.index ["user_id"], name: "index_users_groups_on_user_id"
  end

  add_foreign_key "events", "users"
  add_foreign_key "sessions", "users"
end
