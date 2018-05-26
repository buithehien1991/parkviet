class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates_presence_of :name
  validates :code, uniqueness: {scope: :store}, :allow_blank => true
  scope :by_store, ->(store_id) { where(store_id: store_id) }

  enum status: [:active, :inactive, :archived]

  update_index('customers#customer', :self)
end
