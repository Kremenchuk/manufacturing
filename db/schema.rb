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

ActiveRecord::Schema.define(version: 1200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counterparties", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "short_name",             null: false
    t.integer  "c_type",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name",                      null: false
    t.integer  "unit",       default: 0,    null: false
    t.boolean  "for_sale",   default: true
    t.float    "size_l"
    t.float    "size_a"
    t.float    "size_b"
    t.json     "details",    default: {}
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["name"], name: "index_items_on_name", unique: true, using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "name",                          null: false
    t.string   "name_for_print",                null: false
    t.float    "price",                         null: false
    t.integer  "time",                          null: false
    t.boolean  "print",          default: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "unit",       default: 0, null: false
    t.float    "price",                  null: false
    t.float    "weight",                 null: false
    t.float    "area"
    t.float    "volume"
    t.integer  "size_l"
    t.integer  "size_a"
    t.integer  "size_b"
    t.text     "note"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "order_manufacturings", force: :cascade do |t|
    t.string   "number",          null: false
    t.string   "date",            null: false
    t.string   "invoice"
    t.text     "note"
    t.integer  "counterparty_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["counterparty_id"], name: "index_order_manufacturings_on_counterparty_id", using: :btree
  end

  create_table "order_manufacturings_details", force: :cascade do |t|
    t.integer "order_manufacturing_id"
    t.integer "order_manufacturings_detailable_id"
    t.string  "order_manufacturings_detailable_type"
    t.float   "qty",                                  null: false
    t.index ["order_manufacturing_id"], name: "index_order_manufacturings_details_on_order_manufacturing_id", using: :btree
  end

  create_table "payroll_details", force: :cascade do |t|
    t.integer  "order_manufacturing_detail_id"
    t.integer  "payrolls_id"
    t.float    "qty",                           null: false
    t.float    "sum",                           null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["order_manufacturing_detail_id"], name: "index_payroll_details_on_order_manufacturing_detail_id", using: :btree
    t.index ["payrolls_id"], name: "index_payroll_details_on_payrolls_id", using: :btree
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer  "worker_id"
    t.string   "date",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["worker_id"], name: "index_payrolls_on_worker_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "role_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
  end

  create_table "workers", force: :cascade do |t|
    t.string   "first_name",  null: false
    t.string   "middle_name"
    t.string   "last_name",   null: false
    t.string   "position",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
