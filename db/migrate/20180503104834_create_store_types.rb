class CreateStoreTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :store_types do |t|
      t.string :name
      t.string :avatar
      t.string :description
    end
  end
end
