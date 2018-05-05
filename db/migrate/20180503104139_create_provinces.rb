class CreateProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :province_code, unique: true
      t.string :province_type
    end
  end
end
