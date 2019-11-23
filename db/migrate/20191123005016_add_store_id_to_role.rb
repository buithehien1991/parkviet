class AddStoreIdToRole < ActiveRecord::Migration[5.2]
  def change
    add_reference :roles, :store, foreign_key: true
  end
end
