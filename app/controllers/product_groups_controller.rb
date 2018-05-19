class ProductGroupsController < ApplicationController
  before_action :set_product_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  include ApplicationHelper

  def index
    @product_groups = ProductGroup.by_store(current_store.id)
    @options = []
    @product_groups.walk_tree do |group, level|
      @options << ["#{'--' * level} #{group.name}", group.id]
    end
  end

  def create
    @error = false
    @product_group = ProductGroup.new(product_group_params)
    @product_group.user = current_user
    @product_group.store = current_store

    respond_to do |format|
      if @product_group.save
        format.html { redirect_to @product_group, notice: 'Product group was successfully created.' }
        format.json { render :show, status: :created, location: @product_group }
        format.js {
          @product_groups = ProductGroup.by_store(current_store.id)
          @options = []
          @product_groups.walk_tree do |group, level|
            @options << ["#{'--' * level} #{group.name}", group.id]
          end
        }
      else
        @error = true
        format.html { render :new }
        format.json { render json: @product_group.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def edit
  end

  def destroy
    @error = false
    if @product_group.children.size != 0
      @error = true
      @error_message = "Vui lòng xóa hoặc chuyển các nhóm ngành con sang nhóm ngành khác trước khi xóa nhóm ngành này."
    else
      if @product_group.destroy
        @product_groups = ProductGroup.by_store(current_store.id)
      else
        @error = @product_group.errors
      end
    end
  end

  private
  def set_product_group
    @product_group = ProductGroup.find(params[:id])
  end

  def product_group_params
    params.require(:product_group).permit(:name, :parent_id)
  end
end
