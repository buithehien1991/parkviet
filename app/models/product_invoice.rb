class ProductInvoice < ApplicationRecord
  include DocumentLine
  belongs_to :invoice, inverse_of: :product_invoices
end
