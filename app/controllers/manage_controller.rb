class ManageController < StoreController
  def index
    invoices = current_store.invoices.completed
    purchases = current_store.purchases.purchased
    today = invoices.where(date: Date.current)
    render inertia: "workspace/dashboard", props: {
      statistics: {
        revenue_today: today.sum(:final_price), invoices_today: today.count,
        product_count: current_store.products.active.count,
        low_stock: current_store.products.active.where("in_stock <= in_stock_min").count,
        receivable: invoices.sum("final_price - paid"), payable: purchases.sum("final_price - paid")
      },
      recent_invoices: invoices.order(id: :desc).limit(6).as_json(only: [ :id, :code, :final_price, :date, :status ]),
      low_stock_products: current_store.products.active.where("in_stock <= in_stock_min").order(:in_stock).limit(6).as_json(only: [ :id, :name, :code, :in_stock, :basic_unit ])
    }
  end
end
