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
        "product": [],
        "transaction": [],
        "partner": [],
        "report": []
        #"Sổ quỹ": [],
        #"Khuyến mại": [],
        #"Voucher": []
    }
  end
end
