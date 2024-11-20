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

ActiveRecord::Schema[7.1].define(version: 2024_11_20_050945) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendar_invitations", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.bigint "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id", "user_id"], name: "index_calendar_invitations_on_calendar_id_and_user_id", unique: true
    t.index ["calendar_id"], name: "index_calendar_invitations_on_calendar_id"
    t.index ["user_id"], name: "index_calendar_invitations_on_user_id"
  end

  create_table "calendar_notes", force: :cascade do |t|
    t.text "content"
    t.bigint "calendar_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_calendar_notes_on_calendar_id"
    t.index ["user_id"], name: "index_calendar_notes_on_user_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendars_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "calendar_id", null: false
    t.index ["calendar_id"], name: "index_calendars_users_on_calendar_id"
    t.index ["user_id"], name: "index_calendars_users_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "subject"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "start_timezone"
    t.string "end_timezone"
    t.boolean "is_all_day"
    t.boolean "is_block"
    t.boolean "is_readonly"
    t.string "location"
    t.string "recurrence_rule"
    t.string "recurrence_exception"
    t.integer "recurrence_id"
    t.integer "following_id"
    t.bigint "user_id", null: false
    t.bigint "calendar_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_events_on_calendar_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "calendar_id", null: false
    t.bigint "event_id"
    t.bigint "calendar_note_id"
    t.bigint "calendar_invitation_id"
    t.string "action"
    t.string "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_notifications_on_calendar_id"
    t.index ["calendar_invitation_id"], name: "index_notifications_on_calendar_invitation_id"
    t.index ["calendar_note_id"], name: "index_notifications_on_calendar_note_id"
    t.index ["event_id"], name: "index_notifications_on_event_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "calendar_invitations", "calendars"
  add_foreign_key "calendar_invitations", "users"
  add_foreign_key "calendar_notes", "calendars"
  add_foreign_key "calendar_notes", "users"
  add_foreign_key "events", "calendars"
  add_foreign_key "events", "users"
  add_foreign_key "notifications", "calendar_invitations"
  add_foreign_key "notifications", "calendar_notes"
  add_foreign_key "notifications", "calendars"
  add_foreign_key "notifications", "events"
  add_foreign_key "notifications", "users"
end
