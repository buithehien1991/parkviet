class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates_presence_of :name

  scope :by_store, ->(store_id) { where(store_id: store_id) }
end
