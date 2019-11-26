class AddDiscountMoneyToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :discount_money, :integer
  end
end
