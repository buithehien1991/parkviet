class AddBasicUnitToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :basic_unit, :string # Đơn vị cơ bản cho sản phẩm
    add_column :product_purchase_orders, :unit, :string
  end
end
