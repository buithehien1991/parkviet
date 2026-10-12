class SaleController < StoreController
  def index
    permit_store!("invoice_new")
    return if performed?
    render inertia: "workspace/sale", props: {
      products: current_store.products.active.order(:name).as_json(only: [ :id, :name, :code, :sale_price, :in_stock, :basic_unit ]),
      customers: current_store.customers.active.order(:name).as_json(only: [ :id, :name, :phone ]),
      can_create_customer: owner? || current_member&.store_role&.permissions&.include?("customer_new")
    }
  end
end
