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

ActiveRecord::Schema.define(version: 2018_06_05_121658) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "branches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "store_id"
    t.string "name"
    t.string "phone"
    t.string "address"
    t.string "area"
    t.bigint "province_id"
    t.bigint "district_id"
    t.bigint "commune_id"
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commune_id"], name: "index_branches_on_commune_id"
    t.index ["district_id"], name: "index_branches_on_district_id"
    t.index ["province_id"], name: "index_branches_on_province_id"
    t.index ["store_id"], name: "index_branches_on_store_id"
    t.index ["user_id"], name: "index_branches_on_user_id"
  end

  create_table "communes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "commune_code"
    t.string "commune_type"
    t.string "district_code"
    t.index ["district_code"], name: "index_communes_on_district_code"
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "customer_type"
    t.string "name"
    t.string "code"
    t.string "abbr_name"
    t.string "company_name"
    t.string "phone"
    t.date "birthday"
    t.string "address"
    t.string "area"
    t.bigint "province_id"
    t.bigint "district_id"
    t.bigint "commune_id"
    t.string "tax"
    t.integer "sex"
    t.string "email"
    t.string "group"
    t.string "description"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbr_name"], name: "index_customers_on_abbr_name"
    t.index ["code"], name: "index_customers_on_code"
    t.index ["commune_id"], name: "index_customers_on_commune_id"
    t.index ["district_id"], name: "index_customers_on_district_id"
    t.index ["phone"], name: "index_customers_on_phone"
    t.index ["province_id"], name: "index_customers_on_province_id"
    t.index ["store_id"], name: "index_customers_on_store_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "districts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "district_code"
    t.string "district_type"
    t.string "province_code"
    t.index ["province_code"], name: "index_districts_on_province_code"
  end

  create_table "invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "code"
    t.bigint "customer_id"
    t.integer "payment_method"
    t.integer "total_price"
    t.integer "sale_off"
    t.integer "paid"
    t.integer "given_money"
    t.integer "returned_money"
    t.string "note"
    t.bigint "user_id"
    t.integer "seller_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["store_id"], name: "index_invoices_on_store_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "producers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_producers_on_store_id"
    t.index ["user_id"], name: "index_producers_on_user_id"
  end

  create_table "product_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.bigint "user_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_product_groups_on_parent_id"
    t.index ["store_id"], name: "index_product_groups_on_store_id"
    t.index ["user_id"], name: "index_product_groups_on_user_id"
  end

  create_table "product_invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "invoice_id"
    t.integer "quantity"
    t.integer "discount_percent"
    t.integer "discount_money"
    t.integer "final_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_product_invoices_on_invoice_id"
    t.index ["product_id"], name: "index_product_invoices_on_product_id"
  end

  create_table "product_purchases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "purchase_id"
    t.integer "quantity"
    t.integer "unit_price"
    t.integer "discount_percent"
    t.integer "discount_money"
    t.integer "final_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_purchases_on_product_id"
    t.index ["purchase_id"], name: "index_product_purchases_on_purchase_id"
  end

  create_table "product_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_product_types_on_store_id"
    t.index ["user_id"], name: "index_product_types_on_user_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "abbr_name"
    t.text "description"
    t.text "note"
    t.integer "cost_price"
    t.integer "sale_price"
    t.integer "vat"
    t.integer "in_stock"
    t.integer "in_stock_max"
    t.integer "in_stock_min"
    t.integer "producer_id"
    t.integer "product_type_id"
    t.integer "product_group_id"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_products_on_store_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "provinces", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "province_code"
    t.string "province_type"
  end

  create_table "purchases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "code"
    t.bigint "supplier_id"
    t.integer "payment_method"
    t.integer "price"
    t.integer "tax"
    t.integer "total_price"
    t.integer "paid"
    t.integer "dept"
    t.string "note"
    t.bigint "user_id"
    t.integer "purchaser_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.index ["store_id"], name: "index_purchases_on_store_id"
    t.index ["supplier_id"], name: "index_purchases_on_supplier_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "store_kinds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "store_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.string "description"
  end

  create_table "stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "store_name"
    t.string "link"
    t.string "address"
    t.string "area"
    t.bigint "province_id"
    t.bigint "district_id"
    t.bigint "commune_id"
    t.string "phone"
    t.text "description"
    t.string "website"
    t.string "tax"
    t.datetime "expire_date"
    t.bigint "user_id"
    t.bigint "store_type_id"
    t.bigint "store_kind_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commune_id"], name: "index_stores_on_commune_id"
    t.index ["district_id"], name: "index_stores_on_district_id"
    t.index ["province_id"], name: "index_stores_on_province_id"
    t.index ["store_kind_id"], name: "index_stores_on_store_kind_id"
    t.index ["store_type_id"], name: "index_stores_on_store_type_id"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "suppliers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "supplier_type"
    t.string "name"
    t.string "code"
    t.string "abbr_name"
    t.string "company_name"
    t.string "phone"
    t.date "birthday"
    t.string "address"
    t.string "area"
    t.bigint "province_id"
    t.bigint "district_id"
    t.bigint "commune_id"
    t.string "tax"
    t.string "email"
    t.string "group"
    t.string "description"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbr_name"], name: "index_suppliers_on_abbr_name"
    t.index ["code"], name: "index_suppliers_on_code"
    t.index ["commune_id"], name: "index_suppliers_on_commune_id"
    t.index ["district_id"], name: "index_suppliers_on_district_id"
    t.index ["phone"], name: "index_suppliers_on_phone"
    t.index ["province_id"], name: "index_suppliers_on_province_id"
    t.index ["store_id"], name: "index_suppliers_on_store_id"
    t.index ["user_id"], name: "index_suppliers_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fullname"
    t.string "username"
    t.string "abbr_name"
    t.string "phone"
    t.string "address"
    t.string "area"
    t.bigint "province_id"
    t.bigint "district_id"
    t.bigint "commune_id"
    t.string "birthday"
    t.index ["commune_id"], name: "index_users_on_commune_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["district_id"], name: "index_users_on_district_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["province_id"], name: "index_users_on_province_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.integer "store_id"
    t.string "ip"
    t.string "user_agent"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "branches", "communes"
  add_foreign_key "branches", "districts"
  add_foreign_key "branches", "provinces"
  add_foreign_key "branches", "stores"
  add_foreign_key "branches", "users"
  add_foreign_key "customers", "communes"
  add_foreign_key "customers", "districts"
  add_foreign_key "customers", "provinces"
  add_foreign_key "customers", "stores"
  add_foreign_key "customers", "users"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "stores"
  add_foreign_key "invoices", "users"
  add_foreign_key "producers", "stores"
  add_foreign_key "producers", "users"
  add_foreign_key "product_groups", "stores"
  add_foreign_key "product_groups", "users"
  add_foreign_key "product_invoices", "invoices"
  add_foreign_key "product_invoices", "products"
  add_foreign_key "product_purchases", "products"
  add_foreign_key "product_purchases", "purchases"
  add_foreign_key "product_types", "stores"
  add_foreign_key "product_types", "users"
  add_foreign_key "products", "stores"
  add_foreign_key "products", "users"
  add_foreign_key "purchases", "stores"
  add_foreign_key "purchases", "suppliers"
  add_foreign_key "purchases", "users"
  add_foreign_key "stores", "communes"
  add_foreign_key "stores", "districts"
  add_foreign_key "stores", "provinces"
  add_foreign_key "stores", "store_kinds"
  add_foreign_key "stores", "store_types"
  add_foreign_key "stores", "users"
  add_foreign_key "suppliers", "communes"
  add_foreign_key "suppliers", "districts"
  add_foreign_key "suppliers", "provinces"
  add_foreign_key "suppliers", "stores"
  add_foreign_key "suppliers", "users"
end
