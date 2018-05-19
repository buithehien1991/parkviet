class ProductGroupsController < ApplicationController
  before_action :set_product_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    current_store = current_user.stores.first
    @product_groups = ProductGroup.where(store_id: current_store.id)
  end

  def new
  end

  def create
  end

  def edit
  end

  def destroy
  end

  private
  def set_product_group
    @product_group = ProductGroup.find(params[:id])
  end

  def product_group_params
    params.require(:product_group).permit(:name, :parent_id)
  end
end
