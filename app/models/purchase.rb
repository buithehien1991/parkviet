class Purchase < ApplicationRecord
  belongs_to :user

  belongs_to :supplier, optional: true
  belongs_to :purchaser, class_name: 'User', foreign_key: "purchaser_id"
  belongs_to :store

  has_many :product_purchases, dependent: :delete_all
  has_many :products, through: :product_purchases

  accepts_nested_attributes_for :product_purchases

  #validates :name, presence: false, length: {minimum: 2, maximum: 64}
  validates :code, uniqueness: {scope: :store}, length: {minimum: 2, maximum: 32}, :allow_blank => true

  enum status: { created: 0, purchased: 1, cancel: 2 }
  scope :by_store, -> (store_id) { where(store_id: store_id) }
  self.per_page = 10

  scope :active, -> {
    where(status: [:created, :purchased])
  }

  def update_price
    total = 0
    self.product_purchases.each do |pp|
      final_price = pp.quantity * pp.unit_price - pp.discount_money
      pp.final_price = final_price
      total += final_price
    end

    self.discount_money = 0 if discount_money.nil?
    self.paid = 0 if paid.nil?
    self.total_price = total
    self.price = total - discount_money
    self.dept = paid + discount_money - total
  end
end
