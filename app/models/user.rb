class User < ApplicationRecord
  OAuthResult = Struct.new(:user, :error, keyword_init: true) do
    def success?
      error.blank?
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :stores, dependent: :restrict_with_error
  has_many :members, dependent: :destroy
  has_many :member_stores, through: :members, source: :store

  belongs_to :role_record, class_name: "Role", foreign_key: :role_id, inverse_of: :users, optional: true

  store_accessor :settings,
                 :theme,
                 :font,
                 :language,
                 :timezone,
                 :notification_type,
                 :notify_communication_emails,
                 :notify_marketing_emails,
                 :notify_social_emails,
                 :notify_security_emails,
                 :notify_account_activity,
                 :notify_mobile_push

  before_validation :sync_email_uid, if: :email_provider?
  before_validation :sync_legacy_role_from_role_record

  enum :role, { user: 0, admin: 1, moderator: 2, editor: 3, vip: 4, banned: 5 }
  enum :status, { active: 1, inactive: 0 }

  mount_uploader :avatar, AvatarUploader

  validates :name, length: { maximum: 64 }, allow_blank: true
  validates :username, length: { maximum: 32 }, allow_blank: true
  validates :theme, inclusion: { in: %w[light dark system] }, allow_blank: true

  scope :with_admin_access, -> {
    where(role: roles.fetch("admin"))
      .or(where(role_id: Role.with_admin_access.select(:id)))
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email id name role role_id status username]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[role_record]
  end

  def self.from_google_oauth(auth)
    return OAuthResult.new(error: "Google sign in failed.") if auth.blank?

    provider = auth.provider.to_s
    uid = auth.uid.to_s
    info = auth.info

    return OAuthResult.new(error: "Google sign in failed.") if provider.blank? || uid.blank? || info.blank?

    user = find_by(provider:, uid:)
    if user.present? && !user.active_for_authentication?
      return OAuthResult.new(error: "Your account is inactive.")
    end

    return OAuthResult.new(user:) if user.present?

    email = info.email.to_s.downcase.strip.presence
    email_verified = ActiveModel::Type::Boolean.new.cast(info.email_verified)

    unless email.present? && email_verified
      return OAuthResult.new(error: "Google account must have a verified email address.")
    end

    user = find_or_initialize_by(email:)
    if user.persisted? && !user.provider.to_s.in?(%w[ email ])
      return OAuthResult.new(error: "This email is already linked to another sign-in method.")
    end

    if user.persisted?
      return OAuthResult.new(error: "An account with this email already exists. Sign in with your password instead.")
    end

    generated_password = Devise.friendly_token.first(32)

    user.assign_attributes(
      provider:,
      uid:,
      name: user.name.presence || info.name.to_s.presence,
      password: user.new_record? ? generated_password : nil,
      password_confirmation: user.new_record? ? generated_password : nil
    )
    user.save!

    return OAuthResult.new(error: "Your account is inactive.") unless user.active_for_authentication?

    OAuthResult.new(user:)
  rescue ActiveRecord::RecordInvalid => e
    OAuthResult.new(error: e.record.errors.full_messages.to_sentence.presence || "Google sign in failed.")
  rescue ActiveRecord::RecordNotUnique
    OAuthResult.new(error: "Google sign in failed. Please try again.")
  end

  def active_for_authentication?
    super && active?
  end

  def platform_admin?
    role.to_s == "admin"
  end

  def admin_via_role?
    role_record&.admin? || role_record&.grants?("Admin", "manage") || false
  end

  def admin_access?
    platform_admin? || admin_via_role?
  end

  def can_manage_admin?
    admin_access?
  end

  def inactive_message
    return :inactive unless active?

    super
  end

  private

  def sync_legacy_role_from_role_record
    return unless will_save_change_to_role_id? && role_record&.key

    self.role = role_record.admin? ? "admin" : role_record.key if self.class.roles.key?(role_record.key) || role_record.admin?
  end

  def email_provider?
    provider.blank? || provider == "email"
  end

  def sync_email_uid
    self.provider = "email" if provider.blank?
    self.uid = email.to_s if email.present?
  end
end
