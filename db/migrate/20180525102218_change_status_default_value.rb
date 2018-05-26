class ChangeStatusDefaultValue < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :status, :integer, :default => 0
    change_column :customers, :status, :integer, :default => 0
    change_column :suppliers, :status, :integer, :default => 0
  end
end
