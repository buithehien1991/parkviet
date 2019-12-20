class AddFinalPriceToPurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :purchase_orders, :discount_money, :integer
    add_column :purchase_orders, :final_price, :integer
  end
end
