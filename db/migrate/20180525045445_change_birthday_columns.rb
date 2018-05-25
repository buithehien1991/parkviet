class ChangeBirthdayColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :customers, :birthday, :date
  end

  def self.reversible
    change_column :customers, :birthday, :string
  end
end
