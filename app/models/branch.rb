class Branch < ApplicationRecord
  belongs_to :store
  has_many :members, dependent: :restrict_with_error
  validates :name, presence: true
end
