class Supplier < ApplicationRecord
  include Partner
  has_many :purchases, dependent: :restrict_with_error
  has_many :purchase_orders, dependent: :restrict_with_error
end
