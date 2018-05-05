class CreateCommunes < ActiveRecord::Migration[5.2]
  def change
    create_table :communes do |t|
      t.string :name
      t.string :commune_code, unique: true
      t.string :commune_type
      t.string :district_code, index: true
    end
  end
end
