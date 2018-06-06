class AddStoreToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :store, foreign_key: true
    add_reference :purchases, :store, foreign_key: true
  end
end
