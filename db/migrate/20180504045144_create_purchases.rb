class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.string :code
      t.references :supplier, foreign_key: true
      t.integer :payment_method
      t.integer :price
      t.integer :tax
      t.integer :total_price
      t.integer :paid
      t.integer :dept
      t.string :note
      t.references :user, foreign_key: true
      t.integer :purchaser_id, foreign_key: true

      t.datetime :date
      t.timestamps
    end
  end
end
