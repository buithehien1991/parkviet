class CreateDocumentPayments < ActiveRecord::Migration[8.1]
  def change
    create_table :document_payments do |t|
      t.references :store, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :invoice, foreign_key: true
      t.references :purchase, foreign_key: true
      t.string :request_key, null: false
      t.decimal :amount, precision: 18, scale: 2, null: false
      t.string :payment_method, null: false, default: "cash"
      t.date :date, null: false
      t.text :note
      t.timestamps
    end
    add_index :document_payments, [ :store_id, :request_key ], unique: true
    add_check_constraint :document_payments, "amount > 0", name: "document_payments_positive_amount"
    add_check_constraint :document_payments, "(invoice_id IS NOT NULL)::integer + (purchase_id IS NOT NULL)::integer = 1", name: "document_payments_single_document"
  end
end
