class CreateProductPurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :product_purchase_orders do |t|
      t.references :product, foreign_key: true
      t.references :purchase_order, foreign_key: true
      t.integer :quantity
      t.integer :unit_price
      t.integer :discount_percent
      t.integer :discount_money
      t.integer :total_price
      t.references :supplier, foreign_key: true

      t.timestamps
    end
  end
end
