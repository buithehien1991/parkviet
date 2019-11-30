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

        ],
        "transaction": [
            {preorder: [:index, :new, :edit, :destroy, :reprint, :export_file]},
            {invoice: [:index, :new, :edit, :destroy, :export_file, :print, :copy]},
            {invoice_returns: []},
            {purchase_order: [:view, :new, :update, :delete, :print, :export_file, :new_purchase, :copy]}
        ],
        "partner": [],
        "report": []
        #"Sổ quỹ": [],
        #"Khuyến mại": [],
        #"Voucher": []
    }
  end
end
