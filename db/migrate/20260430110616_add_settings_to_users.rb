class AddSettingsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :settings, :jsonb, null: false, default: {}
  end
end
