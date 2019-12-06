class Supplier < ApplicationRecord
  belongs_to :user
  belongs_to :store
  belongs_to :province, optional: true
  belongs_to :district, optional: true
  belongs_to :commune, optional: true

  validates_presence_of :name
  validates :code, uniqueness: {scope: :store}, :allow_blank => true

  enum status: {active: 0, inactive: 1, archived: 2}

  # update_index('suppliers#supplier', :self)
  has_paper_trail(meta: { store_id: :store_id })
  scope :by_store, ->(store_id) { where(store_id: store_id) }
end
