class Producer < ApplicationRecord
  belongs_to :store
  belongs_to :user

  has_paper_trail(meta: { store_id: :store_id })
  scope :by_store, ->(store_id) { where(store_id: store_id) }
end
