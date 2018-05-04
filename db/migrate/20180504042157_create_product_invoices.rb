class CreateProductInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :product_invoices do |t|
      t.references :product, foreign_key: true
      t.references :invoice, foreign_key: true
      t.integer :quantity
      t.integer :discount_percent
      t.integer :discount_money
      t.integer :final_price

      t.timestamps
    end
  end
end
