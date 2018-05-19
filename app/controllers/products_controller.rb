class ProductsController < ApplicationController
  before_action :authenticate_user!
  def index
    @products = Product.all
  end

  def new
    @product_groups = ProductGroup.where(store_id: current_store.id)
    @product_group_options = []
    @product_groups.walk_tree do |group, level|
      @product_group_options << ["#{'--' * level} #{group.name}", group.id]
    end
  end

  def show

  end
end
