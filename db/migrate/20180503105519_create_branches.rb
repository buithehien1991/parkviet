class CreateBranches < ActiveRecord::Migration[5.2]
  def change
    create_table :branches do |t|
      t.references :store, foreign_key: true
      t.string :name
      t.string :phone
      t.string :address
      t.string :area
      t.references :province, foreign_key: true
      t.references :district, foreign_key: true
      t.references :commune, foreign_key: true
      t.string :description

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
