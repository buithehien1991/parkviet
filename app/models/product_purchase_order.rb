class ProductPurchaseOrder < ApplicationRecord
  include DocumentLine
  belongs_to :purchase_order, inverse_of: :product_purchase_orders
end
