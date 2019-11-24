class AddStatusToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :status, :integer, default: 0
  end
end
