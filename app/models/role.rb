class Role < ApplicationRecord
  belongs_to :store
  serialize :permissions

  scope :by_store, -> (store_id) {where(store_id: store_id)}

  def self.all_permissions
    {
        "system": [
            {generals: [:setting, :history_activity, :dashboard]},
            {users: [:view_user, :add_user, :edit_user, :delete_user]}
        ],
        "product": [
            {product: [:index, :show, :edit, :destroy, :import, :export_file]}
        ],
        "transaction": [
            {preorder: [:view, :new, :edit, :destroy, :reprint, :export_file]},
            {invoice: [:view, :new, :edit, :destroy, :export_file, :print, :copy]},
            {invoice_return: []},
            {purchase_order: [:view, :new, :edit, :delete, :print, :import, :export_file, :new_purchase, :copy, :approve]},
            {purchase_return: []},
            {transfer: []},
            {destroy_product: []}
        ],
        "partner": [
            {customer: []},
            {supplier: []},
        ],
        "report": [
            {daily: [:summary, :product, :income_outcome, :sale]},
            {sale: []},
            {preorder: []},
            {customer: []},
            {supplier: []},
            {user: []}
        ]
    }
  end
end
