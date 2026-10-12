class UpdateUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username, :string, limit: 32
    add_column :users, :name, :string, limit: 64
    add_column :users, :role, :integer, default: 0
    add_column :users, :slug, :string
    add_column :users, :avatar, :string
    add_column :users, :status, :integer, default: 1

    add_column :users, :tokens, :text
    add_column :users, :provider, :string, default: 'email'
    add_column :users, :uid, :string, default: ''

    add_index :users, [ :uid, :provider ], unique: true
    add_index :users, :slug, unique: true
  end
end
