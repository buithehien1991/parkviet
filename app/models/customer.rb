class Customer < ApplicationRecord
  include Partner
  has_many :invoices, dependent: :restrict_with_error
end
