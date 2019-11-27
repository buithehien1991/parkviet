class AddUnitPriceToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :product_invoices, :unit_price, :integer
    add_column :product_invoices, :unit, :string
    add_column :product_purchases, :unit, :string
    add_column :invoices, :final_price, :integer
  end
end
