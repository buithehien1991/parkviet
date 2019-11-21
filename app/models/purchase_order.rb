class PurchaseOrder < ApplicationRecord
  # Đây là model cho yêu cầu nhập hàng. VD khi tạo một yêu cầu nhập hàng và ông chủ có thể phê duyệt để nhân viên đặt hàng có thể thực hiện đặt hàng

  belongs_to :user
  belongs_to :store
  belongs_to :supplier, optional: true
  has_many :products
  has_many :product_purchase_orders, through: :products

  validates :name, presence: true, length: {minimum: 2, maximum: 64}
  validates :code, uniqueness: {scope: :store}, length: {minimum: 2, maximum: 32}, :allow_blank => true

  enum status: { created: 0, confirmed: 1, approved: 2 }
  scope :by_store, -> (store_id) { where(store_id: store_id) }
  self.per_page = 10
end
