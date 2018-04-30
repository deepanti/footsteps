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

ActiveRecord::Schema.define(version: 20170202094643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "announcements", force: :cascade do |t|
    t.string   "url"
    t.string   "message"
    t.string   "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bhakti_sanga_devotees", force: :cascade do |t|
    t.integer  "devotee_id"
    t.integer  "bhakti_sanga_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bhakti_sangas", force: :cascade do |t|
    t.date     "on"
    t.string   "lecture_by"
    t.string   "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "darshans", force: :cascade do |t|
    t.string   "url"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "devotees", force: :cascade do |t|
    t.string   "name"
    t.date     "birthday"
    t.string   "email"
    t.string   "address"
    t.integer  "rounds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade do |t|
    t.string   "url"
    t.string   "name"
    t.string   "author"
    t.string   "category"
    t.string   "author_image_url"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "new_recommendations", force: :cascade do |t|
    t.string   "user_email"
    t.string   "mentor_email"
    t.decimal  "score"
    t.jsonb    "preferences",         default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.boolean  "is_entrepreneur"
    t.boolean  "is_higher_education"
  end

  add_index "new_recommendations", ["mentor_email"], name: "index_new_recommendations_on_mentor_email", using: :btree
  add_index "new_recommendations", ["user_email"], name: "index_new_recommendations_on_user_email", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "company_name"
    t.integer  "company_id"
    t.string   "title"
    t.boolean  "is_current"
    t.string   "location_name"
    t.string   "country"
    t.integer  "start_month"
    t.integer  "start_year"
    t.integer  "end_month"
    t.integer  "end_year"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id"
    t.jsonb    "preferences", default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "sadhna_cards", force: :cascade do |t|
    t.date     "date"
    t.integer  "japa_rounds"
    t.string   "reading"
    t.string   "chad"
    t.time     "wakeup"
    t.time     "rest_time"
    t.string   "hearing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service"
    t.integer  "user_id"
    t.integer  "verses"
    t.string   "service_text"
    t.integer  "slokas_read"
    t.string   "sloka_text"
    t.string   "comments"
    t.integer  "deity_worship"
    t.integer  "devotee_associaton"
    t.string   "reading_type"
    t.string   "reading_book"
  end

  add_index "sadhna_cards", ["user_id"], name: "index_sadhna_cards_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "address"
    t.string   "country"
    t.string   "phone_number"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.integer  "target_rounds"
    t.string   "role",               default: "user"
  end

end
