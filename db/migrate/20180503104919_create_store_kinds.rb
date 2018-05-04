class CreateStoreKinds < ActiveRecord::Migration[5.2]
  def change
    create_table :store_kinds do |t|
      t.string :name
      t.string :description
    end
  end
end
