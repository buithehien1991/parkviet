class CreateProductGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :product_groups do |t|
      t.string :name
      t.integer :parent_id, index: true

      t.references :user, foreign_key: true
      t.references :store, foreign_key: true
      t.timestamps
    end
  end
end
