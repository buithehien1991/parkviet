class Product < ApplicationRecord
  # has_paper_trail(meta: { store_id: :store_id })

  belongs_to :product_group, optional: true
  belongs_to :producer, optional: true
  has_many_attached :images
end
