class Product < ApplicationRecord
  belongs_to :product_group, optional: true
  belongs_to :producer, optional: true
  has_many_attached :images
end
