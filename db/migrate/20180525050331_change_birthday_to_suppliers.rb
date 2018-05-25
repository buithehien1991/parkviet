class ChangeBirthdayToSuppliers < ActiveRecord::Migration[5.2]
  def change
    change_column :suppliers, :birthday, :date
  end
end
