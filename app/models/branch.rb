class Branch < ApplicationRecord
  belongs_to :store
  belongs_to :province, optional: true
  belongs_to :district, optional: true
  belongs_to :commune, optional: true

  has_many_attached :photos
end
