class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :recoverable, :rememberable, :trackable, :validatable

  has_one_attached :avatar
  has_many :stores
end
