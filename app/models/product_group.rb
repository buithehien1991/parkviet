class ProductGroup < ApplicationRecord
  include StoreScoped
  belongs_to :parent, class_name: "ProductGroup", optional: true
  has_many :children, class_name: "ProductGroup", foreign_key: :parent_id, dependent: :restrict_with_error
  has_many :products, dependent: :restrict_with_error
  validates :name, presence: true
  validate do
    validate_store_association(:parent)
    seen = [ id ].compact
    ancestor = parent
    while ancestor
      if seen.include?(ancestor.id)
        errors.add(:parent, "tạo vòng lặp")
        break
      end
      seen << ancestor.id
      ancestor = ancestor.parent
    end
  end
end
