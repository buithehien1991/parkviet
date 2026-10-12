class StoreRole < ApplicationRecord
  belongs_to :store
  has_many :members, dependent: :restrict_with_error
  validates :name, presence: true
  validate :known_permissions

  def self.all_permissions
    {
      system: %w[dashboard setting], user: %w[view new edit delete],
      product: %w[view new edit delete], customer: %w[view new edit delete],
      supplier: %w[view new edit delete], invoice: %w[view new edit delete print],
      purchase: %w[view new edit delete print],
      purchase_order: %w[view new edit delete approve new_purchase print],
      report: %w[view new edit delete]
    }.flat_map { |subject, actions| actions.map { |action| "#{subject}_#{action}" } }
  end

  def self.default_permissions
    %w[product_view customer_view supplier_view invoice_view invoice_new purchase_view purchase_order_view]
  end

  private

  def known_permissions
    unless permissions.is_a?(Array) && (permissions - self.class.all_permissions).empty?
      errors.add(:permissions, "chứa quyền không hợp lệ")
    end
  end
end
