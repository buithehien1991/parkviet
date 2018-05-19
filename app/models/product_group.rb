class ProductGroup < ApplicationRecord
  has_many :products
  belongs_to :store
  belongs_to :user
end
