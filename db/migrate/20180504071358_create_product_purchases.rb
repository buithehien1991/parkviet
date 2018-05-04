class CreateProductPurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :product_purchases do |t|
      t.references :product, foreign_key: true
      t.references :purchase, foreign_key: true
      t.integer :quantity
      t.integer :unit_price
      t.integer :discount_percent
      t.integer :discount_money
      t.integer :final_price

      t.timestamps
    end
  end
end
