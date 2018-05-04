class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :store_name
      t.string :link
      t.string :address
      t.string :area
      t.references :province, foreign_key: true
      t.references :district, foreign_key: true
      t.references :commune, foreign_key: true
      t.string :phone
      t.text :description
      t.string :website
      t.string :tax
      t.datetime :expire_date
      t.references :user, foreign_key: true
      t.references :store_type, foreign_key: true
      t.references :store_kind, foreign_key: true
      t.timestamps
    end
  end
end
