class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates_presence_of :name
  validates :code, uniqueness: {scope: :store}, :allow_blank => true

  enum status: [:active, :inactive, :archived]

  # update_index('customers#customer', :self)
  has_paper_trail(meta: { store_id: :store_id })
  scope :by_store, ->(store_id) { where(store_id: store_id) }
  self.per_page = 10
end
