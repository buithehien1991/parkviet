class Role < ApplicationRecord
  belongs_to :store
  serialize :permissions

  scope :by_store, -> (store_id) {where(store_id: store_id)}

  def self.all_permissions
    {
      system: [:setting, :history_activity, :dashboard],
      user: [:view, :new, :edit, :delete],
      product: [:view, :edit, :delete, :import, :export_file],
      invoice: [:view, :new, :edit, :delete, :export_file, :print, :copy],
      purchase_order: [:view, :new, :edit, :delete, :print, :import, :export_file, :new_purchase, :copy, :approve],
      purchase: [:view, :new, :edit, :delete, :print, :export_file],
      customer: [:view, :new, :edit, :delete],
      supplier: [:view, :new, :edit, :delete]
    }
  end

  def self.default_permissions
    %w(product_view invoice_view purchase_order_view purchase_view customer_view supplier_view)
  end

  # TODO Remove. Only for reference
  def self.permissions
    {
        "system": [
            {generals: [:setting, :history_activity, :dashboard]},
            {users: [:view, :new, :edit, :delete]}
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
