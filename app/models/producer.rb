class Producer < ApplicationRecord
  belongs_to :store
  belongs_to :user

  scope :by_store, ->(store_id) { where(store_id: store_id) }
end
