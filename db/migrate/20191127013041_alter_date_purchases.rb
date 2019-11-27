class AlterDatePurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :time, :time
    change_column :purchases, :date, :date
  end
end
