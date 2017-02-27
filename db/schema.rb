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

  create_table "counterparties", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "short_name",             null: false
    t.integer  "c_type",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "item_details", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "item_detailable_id"
    t.string   "item_detailable_type"
    t.float    "qty",                  null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["item_id"], name: "index_item_details_on_item_id"
  end

  create_table "item_order_manufacturings", force: :cascade do |t|
    t.integer "item_id"
    t.integer "order_manufacturings_id"
    t.float   "qty",                     null: false
    t.index ["item_id"], name: "index_item_order_manufacturings_on_item_id"
    t.index ["order_manufacturings_id"], name: "index_item_order_manufacturings_on_order_manufacturings_id"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.string   "unit"
    t.float    "area"
    t.float    "price"
    t.float    "volume"
    t.float    "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "name"
    t.float    "price"
    t.integer  "time"
    t.boolean  "print"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs_workers", id: false, force: :cascade do |t|
    t.integer "job_id"
    t.integer "worker_id"
    t.index ["job_id"], name: "index_jobs_workers_on_job_id"
    t.index ["worker_id"], name: "index_jobs_workers_on_worker_id"
  end

  create_table "o_m_details", force: :cascade do |t|
    t.integer  "order_manufacturing_id"
    t.integer  "o_m_detailable_id"
    t.string   "o_m_detailable_type"
    t.float    "qty",                    null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["order_manufacturing_id"], name: "index_o_m_details_on_order_manufacturing_id"
  end

  create_table "order_manufacturings", force: :cascade do |t|
    t.string   "number"
    t.string   "date"
    t.string   "invoice"
    t.text     "note"
    t.integer  "counterparty_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["counterparty_id"], name: "index_order_manufacturings_on_counterparty_id"
  end

  create_table "payroll_details", force: :cascade do |t|
    t.integer  "order_manufacturing_detail_id"
    t.integer  "payrolls_id"
    t.float    "qty",                           null: false
    t.float    "sum",                           null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["order_manufacturing_detail_id"], name: "index_payroll_details_on_order_manufacturing_detail_id"
    t.index ["payrolls_id"], name: "index_payroll_details_on_payrolls_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer  "worker_id"
    t.string   "date",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["worker_id"], name: "index_payrolls_on_worker_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
