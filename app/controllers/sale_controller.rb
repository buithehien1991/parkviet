class SaleController < ApplicationController
  layout 'sale'
  def index
    @products = Product.by_store(current_store.id)
  end
end
