class ChangeTypeColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :customers, :type, :customer_type
    rename_column :suppliers, :type, :supplier_type
  end
end
