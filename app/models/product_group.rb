class ProductGroup < ApplicationRecord
  extend ActsAsTree::TreeWalker
  has_many :products
  belongs_to :store
  belongs_to :user

  acts_as_tree order: 'name'

  scope :by_store, ->(store_id) { where(store_id: store_id) }
end
