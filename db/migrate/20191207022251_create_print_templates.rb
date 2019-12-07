class CreatePrintTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :print_templates do |t|
      t.string :name
      t.integer :type
      t.integer :size
      t.mediumtext :template
      t.references :user

      t.timestamps
    end
  end
end
