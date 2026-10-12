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

ActiveRecord::Schema[8.1].define(version: 2026_10_12_000100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    t.index ["blob_id"], name: "index_active_storage_variant_records_on_blob_id"
  end

  create_table "branches", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_branches_on_store_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.string "company_name"
    t.string "phone"
    t.string "email"
    t.date "birthday"
    t.string "address"
    t.string "tax"
    t.string "group"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "code"], name: "index_customers_on_store_id_and_code", unique: true
    t.index ["store_id"], name: "index_customers_on_store_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "document_payments", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "invoice_id"
    t.bigint "purchase_id"
    t.string "request_key", null: false
    t.decimal "amount", precision: 18, scale: 2, null: false
    t.string "payment_method", default: "cash", null: false
    t.date "date", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_document_payments_on_invoice_id"
    t.index ["purchase_id"], name: "index_document_payments_on_purchase_id"
    t.index ["store_id", "request_key"], name: "index_document_payments_on_store_id_and_request_key", unique: true
    t.index ["store_id"], name: "index_document_payments_on_store_id"
    t.index ["user_id"], name: "index_document_payments_on_user_id"
    t.check_constraint "((invoice_id IS NOT NULL)::integer + (purchase_id IS NOT NULL)::integer) = 1", name: "document_payments_single_document"
    t.check_constraint "amount > 0::numeric", name: "document_payments_positive_amount"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "customer_id"
    t.string "name"
    t.string "code", null: false
    t.string "request_key", null: false
    t.date "date", null: false
    t.string "payment_method", default: "cash", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "discount_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "final_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "paid", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "given_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "returned_money", precision: 18, scale: 2, default: "0.0", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["store_id", "code"], name: "index_invoices_on_store_id_and_code", unique: true
    t.index ["store_id", "request_key"], name: "index_invoices_on_store_id_and_request_key", unique: true
    t.index ["store_id"], name: "index_invoices_on_store_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
    t.check_constraint "total_price >= 0::numeric AND discount_money >= 0::numeric AND final_price >= 0::numeric AND paid >= 0::numeric AND given_money >= 0::numeric", name: "invoices_nonnegative_money"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "store_role_id", null: false
    t.bigint "branch_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_members_on_branch_id"
    t.index ["store_id", "user_id"], name: "index_members_on_store_id_and_user_id", unique: true
    t.index ["store_id"], name: "index_members_on_store_id"
    t.index ["store_role_id"], name: "index_members_on_store_role_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.index ["subject", "action"], name: "index_permissions_on_subject_and_action", unique: true
  end

  create_table "print_templates", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "template_type", default: "invoice", null: false
    t.string "size", default: "k80", null: false
    t.text "header"
    t.text "footer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_print_templates_on_store_id"
    t.index ["user_id"], name: "index_print_templates_on_user_id"
  end

  create_table "producers", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_producers_on_store_id"
    t.index ["user_id"], name: "index_producers_on_user_id"
  end

  create_table "product_groups", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_product_groups_on_parent_id"
    t.index ["store_id"], name: "index_product_groups_on_store_id"
    t.index ["user_id"], name: "index_product_groups_on_user_id"
  end

  create_table "product_invoices", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "product_id", null: false
    t.string "unit"
    t.decimal "quantity", precision: 18, scale: 3, null: false
    t.decimal "unit_price", precision: 18, scale: 2, null: false
    t.decimal "discount_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "final_price", precision: 18, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_product_invoices_on_invoice_id"
    t.index ["product_id"], name: "index_product_invoices_on_product_id"
    t.check_constraint "quantity > 0::numeric AND unit_price >= 0::numeric AND discount_money >= 0::numeric AND final_price >= 0::numeric", name: "product_invoices_valid_values"
  end

  create_table "product_purchase_orders", force: :cascade do |t|
    t.bigint "purchase_order_id", null: false
    t.bigint "product_id", null: false
    t.string "unit"
    t.decimal "quantity", precision: 18, scale: 3, null: false
    t.decimal "unit_price", precision: 18, scale: 2, null: false
    t.decimal "discount_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "final_price", precision: 18, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_purchase_orders_on_product_id"
    t.index ["purchase_order_id"], name: "index_product_purchase_orders_on_purchase_order_id"
    t.check_constraint "quantity > 0::numeric AND unit_price >= 0::numeric AND discount_money >= 0::numeric AND final_price >= 0::numeric", name: "product_purchase_orders_valid_values"
  end

  create_table "product_purchases", force: :cascade do |t|
    t.bigint "purchase_id", null: false
    t.bigint "product_id", null: false
    t.string "unit"
    t.decimal "quantity", precision: 18, scale: 3, null: false
    t.decimal "unit_price", precision: 18, scale: 2, null: false
    t.decimal "discount_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "final_price", precision: 18, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_purchases_on_product_id"
    t.index ["purchase_id"], name: "index_product_purchases_on_purchase_id"
    t.check_constraint "quantity > 0::numeric AND unit_price >= 0::numeric AND discount_money >= 0::numeric AND final_price >= 0::numeric", name: "product_purchases_valid_values"
  end

  create_table "product_types", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_product_types_on_store_id"
    t.index ["user_id"], name: "index_product_types_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "producer_id"
    t.bigint "product_group_id"
    t.bigint "product_type_id"
    t.string "name", null: false
    t.string "code", null: false
    t.string "basic_unit", default: "cái", null: false
    t.text "description"
    t.text "note"
    t.decimal "cost_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "sale_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "in_stock", precision: 18, scale: 3, default: "0.0", null: false
    t.decimal "in_stock_min", precision: 18, scale: 3, default: "0.0", null: false
    t.decimal "in_stock_max", precision: 18, scale: 3
    t.integer "vat", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["producer_id"], name: "index_products_on_producer_id"
    t.index ["product_group_id"], name: "index_products_on_product_group_id"
    t.index ["product_type_id"], name: "index_products_on_product_type_id"
    t.index ["store_id", "code"], name: "index_products_on_store_id_and_code", unique: true
    t.index ["store_id"], name: "index_products_on_store_id"
    t.index ["user_id"], name: "index_products_on_user_id"
    t.check_constraint "cost_price >= 0::numeric AND sale_price >= 0::numeric AND in_stock >= 0::numeric AND in_stock_min >= 0::numeric AND vat >= 0 AND vat <= 100", name: "products_nonnegative_values"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "supplier_id"
    t.string "name"
    t.string "code", null: false
    t.string "request_key", null: false
    t.date "date", null: false
    t.string "payment_method", default: "cash", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "discount_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "final_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "paid", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "given_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "returned_money", precision: 18, scale: 2, default: "0.0", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "code"], name: "index_purchase_orders_on_store_id_and_code", unique: true
    t.index ["store_id", "request_key"], name: "index_purchase_orders_on_store_id_and_request_key", unique: true
    t.index ["store_id"], name: "index_purchase_orders_on_store_id"
    t.index ["supplier_id"], name: "index_purchase_orders_on_supplier_id"
    t.index ["user_id"], name: "index_purchase_orders_on_user_id"
    t.check_constraint "total_price >= 0::numeric AND discount_money >= 0::numeric AND final_price >= 0::numeric AND paid >= 0::numeric AND given_money >= 0::numeric", name: "purchase_orders_nonnegative_money"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.bigint "supplier_id"
    t.bigint "purchase_order_id"
    t.string "name"
    t.string "code", null: false
    t.string "request_key", null: false
    t.date "date", null: false
    t.string "payment_method", default: "cash", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "discount_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "final_price", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "paid", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "given_money", precision: 18, scale: 2, default: "0.0", null: false
    t.decimal "returned_money", precision: 18, scale: 2, default: "0.0", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_order_id"], name: "index_purchases_on_purchase_order_id"
    t.index ["store_id", "code"], name: "index_purchases_on_store_id_and_code", unique: true
    t.index ["store_id", "request_key"], name: "index_purchases_on_store_id_and_request_key", unique: true
    t.index ["store_id"], name: "index_purchases_on_store_id"
    t.index ["supplier_id"], name: "index_purchases_on_supplier_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
    t.check_constraint "total_price >= 0::numeric AND discount_money >= 0::numeric AND final_price >= 0::numeric AND paid >= 0::numeric AND given_money >= 0::numeric", name: "purchases_nonnegative_money"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "content"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_reports_on_store_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "permission_id", null: false
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_id_and_permission_id", unique: true
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.boolean "builtin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_roles_on_key", unique: true
  end

  create_table "store_roles", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.string "name", null: false
    t.jsonb "permissions", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_store_roles_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "address"
    t.string "tax"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.string "company_name"
    t.string "phone"
    t.string "email"
    t.date "birthday"
    t.string "address"
    t.string "tax"
    t.string "group"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "code"], name: "index_suppliers_on_store_id_and_code", unique: true
    t.index ["store_id"], name: "index_suppliers_on_store_id"
    t.index ["user_id"], name: "index_suppliers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "name", limit: 64
    t.string "provider", default: "email"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0
    t.bigint "role_id"
    t.jsonb "settings", default: {}, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.string "slug"
    t.integer "status", default: 1
    t.text "tokens"
    t.string "uid", default: ""
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.string "username", limit: 32
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "branches", "stores"
  add_foreign_key "customers", "stores"
  add_foreign_key "customers", "users"
  add_foreign_key "document_payments", "invoices"
  add_foreign_key "document_payments", "purchases"
  add_foreign_key "document_payments", "stores"
  add_foreign_key "document_payments", "users"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "stores"
  add_foreign_key "invoices", "users"
  add_foreign_key "members", "branches"
  add_foreign_key "members", "store_roles"
  add_foreign_key "members", "stores"
  add_foreign_key "members", "users"
  add_foreign_key "print_templates", "stores"
  add_foreign_key "print_templates", "users"
  add_foreign_key "producers", "stores"
  add_foreign_key "producers", "users"
  add_foreign_key "product_groups", "product_groups", column: "parent_id"
  add_foreign_key "product_groups", "stores"
  add_foreign_key "product_groups", "users"
  add_foreign_key "product_invoices", "invoices"
  add_foreign_key "product_invoices", "products"
  add_foreign_key "product_purchase_orders", "products"
  add_foreign_key "product_purchase_orders", "purchase_orders"
  add_foreign_key "product_purchases", "products"
  add_foreign_key "product_purchases", "purchases"
  add_foreign_key "product_types", "stores"
  add_foreign_key "product_types", "users"
  add_foreign_key "products", "producers"
  add_foreign_key "products", "product_groups"
  add_foreign_key "products", "product_types"
  add_foreign_key "products", "stores"
  add_foreign_key "products", "users"
  add_foreign_key "purchase_orders", "stores"
  add_foreign_key "purchase_orders", "suppliers"
  add_foreign_key "purchase_orders", "users"
  add_foreign_key "purchases", "purchase_orders"
  add_foreign_key "purchases", "stores"
  add_foreign_key "purchases", "suppliers"
  add_foreign_key "purchases", "users"
  add_foreign_key "reports", "stores"
  add_foreign_key "reports", "users"
  add_foreign_key "store_roles", "stores"
  add_foreign_key "stores", "users"
  add_foreign_key "suppliers", "stores"
  add_foreign_key "suppliers", "users"
end
