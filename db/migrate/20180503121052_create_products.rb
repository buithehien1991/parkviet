class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.string :abbr_name
      t.text :description
      t.text :note
      t.integer :cost_price
      t.integer :sale_price
      t.integer :vat
      t.integer :in_stock
      t.integer :in_stock_max
      t.integer :in_stock_min
      t.integer :producer_id, foreign_key: true
      t.integer :product_type_id, foreign_key: true
      t.integer :product_group_id, foreign_key: true
      t.integer :status

      t.references :user, foreign_key: true
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end
