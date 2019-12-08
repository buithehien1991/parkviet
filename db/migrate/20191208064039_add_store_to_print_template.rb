class AddStoreToPrintTemplate < ActiveRecord::Migration[5.2]
  def change
    rename_column :print_templates, :type, :template_type
    add_reference :print_templates, :store, foreign_key: true
    add_column :print_templates, :status, :integer, default: 0
    add_reference :reports, :store, foreign_key: true
  end
end
