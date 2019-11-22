class Member < ApplicationRecord
  belongs_to :user
  belongs_to :store
  belongs_to :branch, optional: true
  belongs_to :role, optional: true
end
