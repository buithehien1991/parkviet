class ProductsController < ApplicationController
  before_action :authenticate_user!
  def index
    @products = Product.all
  end

  def new

  end

  def show

  end
end
