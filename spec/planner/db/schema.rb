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

ActiveRecord::Schema[7.2].define(version: 2024_10_02_002317) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diary_calendar_entries", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "title"
    t.text "description"
    t.string "schedulable_type", null: false
    t.bigint "schedulable_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "cancellation_reason"
    t.boolean "cancelled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_diary_calendar_entries_on_owner"
    t.index ["schedulable_type", "schedulable_id"], name: "index_diary_calendar_entries_on_schedulable"
  end

  create_table "diary_calendar_invites", force: :cascade do |t|
    t.bigint "diary_calendar_entry_id", null: false
    t.string "invitee_type", null: false
    t.bigint "invitee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diary_calendar_entry_id"], name: "index_diary_calendar_invites_on_diary_calendar_entry_id"
    t.index ["invitee_type", "invitee_id"], name: "index_diary_calendar_invites_on_invitee"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "calendar_token"
    t.datetime "calendar_token_created_at", precision: nil
    t.index ["calendar_token"], name: "index_users_on_calendar_token", unique: true
  end

  add_foreign_key "diary_calendar_invites", "diary_calendar_entries"
end
