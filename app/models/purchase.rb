class Purchase < ApplicationRecord
  include BusinessDocument
  belongs_to :supplier, optional: true
  belongs_to :purchase_order, optional: true
  has_many :product_purchases, inverse_of: :purchase, dependent: :destroy
  has_many :document_payments, dependent: :restrict_with_error
  accepts_nested_attributes_for :product_purchases, allow_destroy: true
  enum :status, { created: 0, purchased: 1, canceled: 2 }
end
