class PurchaseOrder < ApplicationRecord
  include BusinessDocument
  belongs_to :supplier, optional: true
  has_many :product_purchase_orders, inverse_of: :purchase_order, dependent: :destroy
  has_many :purchases, dependent: :restrict_with_error
  accepts_nested_attributes_for :product_purchase_orders, allow_destroy: true
  enum :status, { created: 0, checking: 1, checked: 2, confirmed: 3, completed: 4, canceled: 5, approved: 6 }
  validates :name, presence: true

  def received_quantities
    ProductPurchase.joins(:purchase).where(purchases: { purchase_order_id: id, status: Purchase.statuses.fetch("purchased") })
      .group(:product_id).sum(:quantity)
  end

  def remaining_quantities
    received = received_quantities
    lines.group_by(&:product_id).transform_values { |items| items.sum(&:quantity) }
      .transform_keys(&:to_i).to_h { |product_id, ordered| [ product_id, [ ordered - received.fetch(product_id, 0), 0 ].max ] }
  end
end
