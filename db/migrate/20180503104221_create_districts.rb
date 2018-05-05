class CreateDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :districts do |t|
      t.string :name
      t.string :district_code, unique: true
      t.string :district_type
      t.string :province_code, index: true
    end
  end
end
