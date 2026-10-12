module DocumentLine
  extend ActiveSupport::Concern

  included do
    belongs_to :product
    before_validation :calculate_price
    validates :quantity, numericality: { greater_than: 0 }
    validates :unit_price, :discount_money, numericality: { greater_than_or_equal_to: 0 }
    validate :valid_line
  end

  def calculate_price
    self.final_price = (quantity.to_d * unit_price.to_d - discount_money.to_d).round(2)
    self.unit ||= product&.basic_unit
  end

  private

  def valid_line
    errors.add(:discount_money, "vượt quá giá trị dòng") if final_price.to_d.negative?
    document = public_send(self.class.name.delete_prefix("Product").underscore)
    errors.add(:product, "không thuộc cửa hàng") if product && document && product.store_id != document.store_id
  end
end
