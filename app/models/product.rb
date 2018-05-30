class Product < ApplicationRecord
  # has_paper_trail(meta: { store_id: :store_id })
  belongs_to :user
  belongs_to :store
  belongs_to :product_group, optional: true
  belongs_to :producer, optional: true
  has_many_attached :images

  validates :name, presence: true, length: {minimum: 2, maximum: 64}
  validates :code, uniqueness: {scope: :store}, length: {minimum: 2, maximum: 32}, :allow_blank => true
  validates :cost_price, numericality: true, :allow_blank => true
  validates :sale_price, numericality: true, :allow_blank => true
  validates :in_stock, numericality: {only_integer: true}, :allow_blank => true
  validates :in_stock_min, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than: 1000000000}, :allow_nil  => true
  validates :in_stock_max, numericality: {only_integer: true, greater_than: :in_stock_min, less_than: 1000000000}, :allow_nil  => true
  validates :vat, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, :allow_nil  => true

  enum status: { active: 0, inactive: 1, archived: 2 }

  scope :by_store, -> (store_id) { where(store_id: store_id) }
  self.per_page = 10
end
