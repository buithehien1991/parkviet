class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :recoverable, :rememberable, :trackable, :validatable

  has_one_attached :avatar
  has_many :stores
  belongs_to :province, optional: true
  belongs_to :district, optional: true
  belongs_to :commune, optional: true
  has_many :members, dependent: :delete_all

  attr_accessor :login

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end
end
