class Product < ApplicationRecord
  include StoreScoped
  belongs_to :product_group, optional: true
  belongs_to :producer, optional: true
  belongs_to :product_type, optional: true
  has_many_attached :images
  has_many :product_invoices, dependent: :restrict_with_error
  has_many :product_purchases, dependent: :restrict_with_error
  has_many :product_purchase_orders, dependent: :restrict_with_error
  enum :status, { active: 0, inactive: 1, archived: 2 }
  before_validation :assign_code
  validates :name, presence: true, length: { maximum: 100 }
  validates :code, presence: true, uniqueness: { scope: :store_id }
  validates :cost_price, :sale_price, :in_stock, :in_stock_min, numericality: { greater_than_or_equal_to: 0 }
  validates :in_stock_max, numericality: { greater_than_or_equal_to: :in_stock_min }, allow_nil: true
  validates :vat, numericality: { only_integer: true, in: 0..100 }
  validate { [ :producer, :product_group, :product_type ].each { |name| validate_store_association(name) } }

  private

  def assign_code
    self.code = "HH#{SecureRandom.hex(5).upcase}" if code.blank?
  end
end
