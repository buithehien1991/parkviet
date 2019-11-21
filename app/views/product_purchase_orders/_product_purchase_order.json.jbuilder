json.extract! product_purchase_order, :id, :product_id, :purchase_order_id, :quantity, :unit_price, :created_at, :updated_at
json.url product_purchase_order_url(product_purchase_order, format: :json)
