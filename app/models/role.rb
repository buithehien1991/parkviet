class Role < ApplicationRecord
  belongs_to :store

  scope :by_store, -> (store_id) { where(store_id: store_id) }
end
