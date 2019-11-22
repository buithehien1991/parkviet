class Role < ApplicationRecord
  scope :by_store, -> (store_id) { where(store_id: store_id) }
end
