class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :code, :customer_id, :payment_method, :total_price, :sale_off, :paid, :given_money, :returned_money, :note, :user_id, :seller_id, :store_id, :final_price, :time, :date
  belongs_to :customer
  belongs_to :seller

  has_many :product_invoices, each_serializer: ProductInvoiceSerializer
end