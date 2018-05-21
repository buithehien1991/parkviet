class AddStoreToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :store_id, :integer
    add_column :versions, :ip, :string
    add_column :versions, :user_agent, :string
  end
end
