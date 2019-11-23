class Store < ApplicationRecord
  belongs_to :user
  belongs_to :province, optional: true
  belongs_to :district, optional: true
  belongs_to :commune, optional: true
  belongs_to :store_type
  belongs_to :store_kind, optional: true

  has_many :roles
  has_many :members
  has_many_attached :photos
end
