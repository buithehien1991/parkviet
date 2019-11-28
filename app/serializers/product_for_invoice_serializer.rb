class ProductForInvoiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :cost_price, :sale_price, :vat, :in_stock, :in_stock_max, :in_stock_min, :status, :basic_unit
end