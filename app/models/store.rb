class Store < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :restrict_with_error
  has_many :store_roles, dependent: :restrict_with_error
  has_many :branches, dependent: :restrict_with_error
  has_many :products, dependent: :restrict_with_error
  has_many :customers, dependent: :restrict_with_error
  has_many :suppliers, dependent: :restrict_with_error
  has_many :invoices, dependent: :restrict_with_error
  has_many :purchases, dependent: :restrict_with_error
  has_many :purchase_orders, dependent: :restrict_with_error
  has_many :producers, dependent: :restrict_with_error
  has_many :product_groups, dependent: :restrict_with_error
  has_many :product_types, dependent: :restrict_with_error
  has_many :reports, dependent: :restrict_with_error
  has_many :print_templates, dependent: :restrict_with_error
  validates :name, presence: true, length: { maximum: 100 }
  after_create :create_default_role

  private

  def create_default_role
    store_roles.create!(name: "Nhân viên", permissions: StoreRole.default_permissions)
  end
end
