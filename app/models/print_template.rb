class PrintTemplate < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :store

  enum size: {a4: 0, a5: 1, k80: 2, k58: 3}
  enum template_type: {invoice: 0, purchase: 1, purchase_order: 2}

  scope :by_store, ->(store_id) { where(store_id: store_id) }
  scope :by_type, -> (type) {
    where(template_type: type.to_sym)
  }

  scope :by_store_and_type, -> (store_id, type) {
    where(store_id: store_id, template_type: type.to_sym)
  }
end
