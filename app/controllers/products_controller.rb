class ProductsController < ApplicationController
  before_action :authenticate_user!
  def index
    @products = Product.all
  end

  def new
    @product_groups = ProductGroup.by_store(current_store.id)
    @product_group_options = []
    @product_groups.walk_tree do |group, level|
      @product_group_options << ["#{'--' * level} #{group.name}", group.id]
    end

    @producers = Producer.by_store(current_store.id)
  end

  def show

  end

  private
  def product_params
    params.require(:product).permit(images: [])
  end
end
