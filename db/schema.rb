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

ActiveRecord::Schema.define(version: 2022_04_21_124322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counterparties", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.integer "c_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_details", id: :serial, force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "detailable_type"
    t.integer "detailable_id"
    t.float "qty", default: 0.0, null: false
    t.boolean "print_in_o_m", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["detailable_type", "detailable_id"], name: "index_item_details_on_detailable_type_and_detailable_id"
    t.index ["item_id"], name: "index_item_details_on_item_id"
  end

  create_table "item_groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "range", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "unit", default: 0, null: false
    t.boolean "for_sale", default: true
    t.float "size_l"
    t.float "size_a"
    t.float "size_b"
    t.float "area"
    t.float "volume"
    t.integer "item_group_id"
    t.json "item_files"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "print_in_collection", default: true
    t.index ["item_group_id"], name: "index_items_on_item_group_id"
    t.index ["name"], name: "index_items_on_name", unique: true
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "name_for_print", null: false
    t.float "price", null: false
    t.integer "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "print_in_collection", default: true
  end

  create_table "materials", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "unit", default: 0, null: false
    t.float "price", null: false
    t.float "weight", null: false
    t.float "area"
    t.float "volume"
    t.integer "size_l"
    t.integer "size_a"
    t.integer "size_b"
    t.text "note"
    t.float "qty", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "manual_write_off", default: false
    t.boolean "round_one", default: false
  end

  create_table "order_manufacturings", id: :serial, force: :cascade do |t|
    t.string "number", null: false
    t.string "start_date", null: false
    t.string "finish_date", null: false
    t.string "invoice"
    t.text "note"
    t.integer "o_m_status", default: 0
    t.float "total_price"
    t.float "con_pay"
    t.float "extra_charge"
    t.float "indirect_costs"
    t.float "payroll_taxes"
    t.integer "counterparty_id"
    t.integer "user_id"
    t.json "o_m_files"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["counterparty_id"], name: "index_order_manufacturings_on_counterparty_id"
    t.index ["user_id"], name: "index_order_manufacturings_on_user_id"
  end

  create_table "order_manufacturings_details", id: :serial, force: :cascade do |t|
    t.integer "order_manufacturing_id"
    t.integer "item_id"
    t.float "qty", null: false
    t.index ["item_id"], name: "index_order_manufacturings_details_on_item_id"
    t.index ["order_manufacturing_id"], name: "index_order_manufacturings_details_on_order_manufacturing_id"
  end

  create_table "orders_manual_materials", id: :serial, force: :cascade do |t|
    t.integer "order_manufacturing_id"
    t.integer "material_id"
    t.float "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_orders_manual_materials_on_material_id"
    t.index ["order_manufacturing_id"], name: "index_orders_manual_materials_on_order_manufacturing_id"
  end

  create_table "payroll_details", id: :serial, force: :cascade do |t|
    t.integer "order_manufacturing_id"
    t.integer "payroll_id"
    t.integer "job_id"
    t.float "qty", null: false
    t.float "sum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "residual_qty", default: 0.0
    t.index ["job_id"], name: "index_payroll_details_on_job_id"
    t.index ["order_manufacturing_id"], name: "index_payroll_details_on_order_manufacturing_id"
    t.index ["payroll_id"], name: "index_payroll_details_on_payroll_id"
  end

  create_table "payrolls", id: :serial, force: :cascade do |t|
    t.integer "worker_id"
    t.string "number", null: false
    t.string "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["worker_id"], name: "index_payrolls_on_worker_id"
  end

  create_table "purchase_invoices", id: :serial, force: :cascade do |t|
    t.integer "counterparty_id"
    t.string "number", null: false
    t.string "date", null: false
    t.float "total_price", null: false
    t.float "we_pay", null: false
    t.integer "p_i_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.index ["counterparty_id"], name: "index_purchase_invoices_on_counterparty_id"
  end

  create_table "purchase_invoices_details", id: :serial, force: :cascade do |t|
    t.integer "purchase_invoice_id"
    t.integer "material_id"
    t.float "qty", null: false
    t.float "price", null: false
    t.index ["material_id"], name: "index_purchase_invoices_details_on_material_id"
    t.index ["purchase_invoice_id"], name: "index_purchase_invoices_details_on_purchase_invoice_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "available_classes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale", default: "ru"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "workers", id: :serial, force: :cascade do |t|
    t.string "fio", null: false
    t.string "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
