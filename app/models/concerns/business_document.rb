module BusinessDocument
  extend ActiveSupport::Concern
  include StoreScoped

  included do
    before_validation :defaults_and_totals, if: -> { new_record? || created? }
    validates :code, presence: true, uniqueness: { scope: :store_id }
    validates :request_key, presence: true, uniqueness: { scope: :store_id }
    validates :date, presence: true
    validates :payment_method, inclusion: { in: %w[cash transfer card] }
    validates :discount_money, :paid, :given_money, numericality: { greater_than_or_equal_to: 0 }
    validate :valid_totals
  end

  def line_association
    { "Invoice" => :product_invoices, "Purchase" => :product_purchases, "PurchaseOrder" => :product_purchase_orders }.fetch(self.class.name)
  end

  def lines
    public_send(line_association)
  end

  private

  def defaults_and_totals
    prefix = { "Invoice" => "HD", "Purchase" => "PC", "PurchaseOrder" => "DHN" }.fetch(self.class.name)
    self.code = "#{prefix}#{SecureRandom.hex(5).upcase}" if code.blank?
    self.request_key = SecureRandom.uuid if request_key.blank?
    self.date ||= Date.current
    lines.each(&:calculate_price)
    self.total_price = lines.reject(&:marked_for_destruction?).sum { |line| line.final_price || 0 }
    self.final_price = total_price - (discount_money || 0)
    self.returned_money = is_a?(Invoice) ? [ given_money.to_d - paid.to_d, 0 ].max : 0
  end

  def valid_totals
    errors.add(:base, "Chứng từ cần ít nhất một sản phẩm") if lines.reject(&:marked_for_destruction?).empty?
    errors.add(:discount_money, "vượt quá tổng tiền") if discount_money.to_d > total_price.to_d
    errors.add(:paid, "vượt quá tiền phải trả") if paid.to_d > final_price.to_d
    if is_a?(Invoice) && (new_record? || created?) && given_money.to_d.positive? && given_money.to_d < paid.to_d
      errors.add(:given_money, "nhỏ hơn số tiền thanh toán")
    end
    validate_store_association(is_a?(Invoice) ? :customer : :supplier)
    validate_store_association(:purchase_order) if is_a?(Purchase)
  end
end
