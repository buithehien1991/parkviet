class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :code
      t.references :customer, foreign_key: true
      t.integer :payment_method
      t.integer :total_price
      t.integer :sale_off
      t.integer :paid
      t.integer :given_money
      t.integer :returned_money
      t.string :note
      t.references :user, foreign_key: true
      t.integer :seller_id, foreign_key: true

      t.datetime :date
      t.timestamps
    end
  end
end
