class AlterDateInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :time, :time
    change_column :invoices, :date, :date
  end
end
