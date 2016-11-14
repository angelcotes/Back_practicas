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

ActiveRecord::Schema.define(version: 20160919054717) do

  create_table "activities", force: :cascade do |t|
    t.string   "name_activity"
    t.integer  "range"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "start_date"
    t.datetime "finish_date"
    t.integer  "duration"
    t.integer  "course_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "activities", ["course_id"], name: "index_activities_on_course_id"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "nrc"
    t.integer  "user_id"
    t.string   "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "documents", force: :cascade do |t|
    t.string   "type_document"
    t.string   "address"
    t.integer  "member_id"
    t.integer  "group_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "documents", ["group_id"], name: "index_documents_on_group_id"
  add_index "documents", ["member_id"], name: "index_documents_on_member_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name_group"
    t.integer  "activity_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "groups", ["activity_id"], name: "index_groups_on_activity_id"

  create_table "members", force: :cascade do |t|
    t.string   "rol"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "time_start"
    t.integer  "duration"
    t.string   "status",        default: "habilitado"
    t.datetime "time_pause"
    t.datetime "time_finished"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "members", ["group_id"], name: "index_members_on_group_id"
  add_index "members", ["user_id"], name: "index_members_on_user_id"

  create_table "students", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "students", ["course_id"], name: "index_students_on_course_id"
  add_index "students", ["user_id"], name: "index_students_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "users_type"
    t.string   "email"
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

end
