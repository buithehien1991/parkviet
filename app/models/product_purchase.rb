class ProductPurchase < ApplicationRecord
  include DocumentLine
  belongs_to :purchase, inverse_of: :product_purchases
end
