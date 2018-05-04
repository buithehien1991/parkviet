class CreateCommunes < ActiveRecord::Migration[5.2]
  def change
    create_table :communes do |t|
      t.string :name
      t.references :district, foreign_key: true
      t.references :province, foreign_key: true
    end
  end
end
