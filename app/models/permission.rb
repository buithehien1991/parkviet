class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions

  validates :subject, presence: true
  validates :action, presence: true, uniqueness: { scope: :subject, case_sensitive: false }
  validate :must_be_in_catalog

  scope :ordered, -> { order(:subject, :action) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[action created_at id subject updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def must_be_in_catalog
    return if PermissionCatalog.action?(subject, action)

    errors.add(:base, "(#{subject}, #{action}) is not in PermissionCatalog")
  end
end
