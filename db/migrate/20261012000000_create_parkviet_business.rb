class CreateParkvietBusiness < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :phone
      t.string :address
      t.string :tax
      t.text :description
      t.timestamps
    end

    create_table :branches do |t|
      t.references :store, null: false, foreign_key: true
      t.string :name, null: false
      t.string :phone
      t.string :address
      t.timestamps
    end

    create_table :store_roles do |t|
      t.references :store, null: false, foreign_key: true
      t.string :name, null: false
      t.jsonb :permissions, default: [], null: false
      t.timestamps
    end

    create_table :members do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :store_role, null: false, foreign_key: true
      t.references :branch, foreign_key: true
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :members, [ :store_id, :user_id ], unique: true

    [ :producers, :product_groups, :product_types ].each do |table|
      create_table table do |t|
        t.references :store, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
        t.string :name, null: false
        t.references :parent, foreign_key: { to_table: :product_groups } if table == :product_groups
        t.timestamps
      end
    end

    create_table :products do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :producer, foreign_key: true
      t.references :product_group, foreign_key: true
      t.references :product_type, foreign_key: true
      t.string :name, null: false
      t.string :code, null: false
      t.string :basic_unit, default: "cái", null: false
      t.text :description
      t.text :note
      t.decimal :cost_price, precision: 18, scale: 2, default: 0, null: false
      t.decimal :sale_price, precision: 18, scale: 2, default: 0, null: false
      t.decimal :in_stock, precision: 18, scale: 3, default: 0, null: false
      t.decimal :in_stock_min, precision: 18, scale: 3, default: 0, null: false
      t.decimal :in_stock_max, precision: 18, scale: 3
      t.integer :vat, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
    add_index :products, [ :store_id, :code ], unique: true
    add_check_constraint :products, "cost_price >= 0 AND sale_price >= 0 AND in_stock >= 0 AND in_stock_min >= 0 AND vat BETWEEN 0 AND 100", name: "products_nonnegative_values"

    [ :customers, :suppliers ].each do |table|
      create_table table do |t|
        t.references :store, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
        t.string :name, null: false
        t.string :code, null: false
        t.string :company_name
        t.string :phone
        t.string :email
        t.date :birthday
        t.string :address
        t.string :tax
        t.string :group
        t.text :description
        t.integer :status, default: 0, null: false
        t.timestamps
      end
      add_index table, [ :store_id, :code ], unique: true
    end

    [ :purchase_orders, :purchases, :invoices ].each do |table|
      create_table table do |t|
        t.references :store, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
        t.references(table == :invoices ? :customer : :supplier, foreign_key: true)
        t.references :purchase_order, foreign_key: true if table == :purchases
        t.string :name
        t.string :code, null: false
        t.string :request_key, null: false
        t.date :date, null: false
        t.string :payment_method, default: "cash", null: false
        t.integer :status, default: 0, null: false
        t.decimal :total_price, precision: 18, scale: 2, default: 0, null: false
        t.decimal :discount_money, precision: 18, scale: 2, default: 0, null: false
        t.decimal :final_price, precision: 18, scale: 2, default: 0, null: false
        t.decimal :paid, precision: 18, scale: 2, default: 0, null: false
        t.decimal :given_money, precision: 18, scale: 2, default: 0, null: false
        t.decimal :returned_money, precision: 18, scale: 2, default: 0, null: false
        t.text :note
        t.timestamps
      end
      add_index table, [ :store_id, :code ], unique: true
      add_index table, [ :store_id, :request_key ], unique: true
      add_check_constraint table, "total_price >= 0 AND discount_money >= 0 AND final_price >= 0 AND paid >= 0 AND given_money >= 0", name: "#{table}_nonnegative_money"
    end

    { product_invoices: :invoice, product_purchases: :purchase, product_purchase_orders: :purchase_order }.each do |table, document|
      create_table table do |t|
        t.references document, null: false, foreign_key: true
        t.references :product, null: false, foreign_key: true
        t.string :unit
        t.decimal :quantity, precision: 18, scale: 3, null: false
        t.decimal :unit_price, precision: 18, scale: 2, null: false
        t.decimal :discount_money, precision: 18, scale: 2, default: 0, null: false
        t.decimal :final_price, precision: 18, scale: 2, null: false
        t.timestamps
      end
      add_check_constraint table, "quantity > 0 AND unit_price >= 0 AND discount_money >= 0 AND final_price >= 0", name: "#{table}_valid_values"
    end

    create_table :reports do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content
      t.integer :status, default: 0, null: false
      t.timestamps
    end

    create_table :print_templates do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :template_type, default: "invoice", null: false
      t.string :size, default: "k80", null: false
      t.text :header
      t.text :footer
      t.timestamps
    end

    create_table :active_storage_blobs do |t|
      t.string :key, null: false
      t.string :filename, null: false
      t.string :content_type
      t.text :metadata
      t.string :service_name, null: false
      t.bigint :byte_size, null: false
      t.string :checksum
      t.datetime :created_at, null: false
      t.index :key, unique: true
    end
    create_table :active_storage_attachments do |t|
      t.string :name, null: false
      t.references :record, null: false, polymorphic: true, index: false
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }
      t.datetime :created_at, null: false
      t.index [ :record_type, :record_id, :name, :blob_id ], unique: true, name: "index_active_storage_attachments_uniqueness"
    end
    create_table :active_storage_variant_records do |t|
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }
      t.string :variation_digest, null: false
      t.index [ :blob_id, :variation_digest ], unique: true, name: "index_active_storage_variant_records_uniqueness"
    end
  end
end
