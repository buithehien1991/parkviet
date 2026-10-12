class Producer < ApplicationRecord
  include StoreScoped
  has_many :products, dependent: :restrict_with_error
  validates :name, presence: true
end
