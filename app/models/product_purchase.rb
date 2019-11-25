class ProductPurchase < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :purchase
end
