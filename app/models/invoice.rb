class Invoice < ApplicationRecord
  include BusinessDocument
  belongs_to :customer, optional: true
  has_many :product_invoices, inverse_of: :invoice, dependent: :destroy
  has_many :document_payments, dependent: :restrict_with_error
  accepts_nested_attributes_for :product_invoices, allow_destroy: true
  enum :status, { created: 0, completed: 1, canceled: 2 }
end
