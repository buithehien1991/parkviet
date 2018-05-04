class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.integer :type
      t.string :name
      t.string :code, index: true
      t.string :abbr_name, index: true
      t.string :company_name
      t.string :phone, index: true
      t.string :birthday
      t.string :address
      t.string :area
      t.references :province, foreign_key: true
      t.references :district, foreign_key: true
      t.references :commune, foreign_key: true
      t.string :tax
      t.integer :sex
      t.string :email
      t.string :group
      t.string :description
      t.integer :status
      t.references :user, foreign_key: true
      t.references :store, foreign_key: true
      t.timestamps
    end
  end
end
