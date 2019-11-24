class AddStatusToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :status, :integer, default: 0
    add_column :purchases, :name, :string
  end
end
