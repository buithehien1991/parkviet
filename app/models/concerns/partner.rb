module Partner
  extend ActiveSupport::Concern
  include StoreScoped

  included do
    enum :status, { active: 0, inactive: 1, archived: 2 }
    before_validation :assign_code
    validates :name, presence: true
    validates :code, presence: true, uniqueness: { scope: :store_id }
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  end

  private

  def assign_code
    prefix = is_a?(Customer) ? "KH" : "NCC"
    self.code = "#{prefix}#{SecureRandom.hex(5).upcase}" if code.blank?
  end
end
