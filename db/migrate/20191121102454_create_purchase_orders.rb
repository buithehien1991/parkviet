class CreatePurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_orders do |t|
      t.string :name
      t.string :code
      t.integer :status, default: 0
      t.text :note
      t.integer :total_price

      t.references :supplier, foreign_key: true
      t.references :user, foreign_key: true
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end
