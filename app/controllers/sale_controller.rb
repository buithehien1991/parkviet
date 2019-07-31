class SaleController < ApplicationController
  before_action :authenticate_user!

  layout 'sale'
  layout 'sale_html', only: 'dashboard'
  def index
    @products = Product.by_store(current_store.id)
  end

  def dashboard
    @products = Product.by_store(current_store.id)
  end
end
