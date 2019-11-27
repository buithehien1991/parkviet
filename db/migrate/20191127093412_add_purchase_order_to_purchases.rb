class AddPurchaseOrderToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_reference :purchases, :purchase_order
  end
end
