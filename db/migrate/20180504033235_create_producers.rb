class CreateProducers < ActiveRecord::Migration[5.2]
  def change
    create_table :producers do |t|
      t.string :name

      t.references :user, foreign_key: true
      t.references :store, foreign_key: true
      t.timestamps
    end
  end
end
