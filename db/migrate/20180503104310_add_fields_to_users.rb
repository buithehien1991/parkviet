class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :fullname, :string
    add_column :users, :username, :string
    add_column :users, :abbr_name, :string
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :area, :string
    add_reference :users, :province, index: true
    add_reference :users, :district, index: true
    add_reference :users, :commune, index: true
    add_column :users, :birthday, :string
  end
end
