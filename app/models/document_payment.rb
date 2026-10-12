class DocumentPayment < ApplicationRecord
  include StoreScoped
  belongs_to :invoice, optional: true
  belongs_to :purchase, optional: true
  validates :amount, numericality: { greater_than: 0 }
  validates :date, :request_key, presence: true
  validates :request_key, uniqueness: { scope: :store_id }
  validates :payment_method, inclusion: { in: %w[cash transfer card] }
  validate do
    errors.add(:base, "Cần đúng một chứng từ") unless [ invoice, purchase ].compact.size == 1
    validate_store_association(:invoice)
    validate_store_association(:purchase)
  end

  def document
    invoice || purchase
  end
end
