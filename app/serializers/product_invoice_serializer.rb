class ProductInvoiceSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :invoice_id, :quantity, :discount_percent, :discount_money, :final_price, :unit_price, :unit
  belongs_to :product, serializer: ProductForInvoiceSerializer
end