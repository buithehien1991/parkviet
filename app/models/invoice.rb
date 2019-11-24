class Invoice < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :user
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :store

  has_many :product_invoices, dependent: :delete_all
  has_many :products, through: :product_invoices

  validates :name, presence: false, length: {minimum: 2, maximum: 64}
  validates :code, uniqueness: {scope: :store}, length: {minimum: 2, maximum: 32}, :allow_blank => true

  enum status: { created: 0 }
  scope :by_store, -> (store_id) { where(store_id: store_id) }
  self.per_page = 10
end
