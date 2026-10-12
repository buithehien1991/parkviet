class Role < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
  has_many :users, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 64 }
  validates :key, presence: true,
                  uniqueness: { case_sensitive: false },
                  length: { maximum: 64 },
                  format: { with: /\A[a-z][a-z0-9_]*\z/ }

  before_validation :normalize_key

  scope :ordered, -> { order(:position, :name) }
  scope :builtin, -> { where(builtin: true) }
  scope :with_admin_access, -> {
    left_joins(:permissions)
      .where(admin: true)
      .or(left_joins(:permissions).where(permissions: { subject: "Admin", action: "manage" }))
      .distinct
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[admin builtin created_at id key name position updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[permissions]
  end

  def admin?
    !!admin
  end

  def grants?(subject, action)
    admin? || permissions.exists?(subject: subject.to_s, action: action.to_s)
  end

  private

  def normalize_key
    self.key = key.to_s.strip.downcase.presence
  end
end
