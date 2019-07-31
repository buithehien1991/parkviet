class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :update_status]
  before_action :authenticate_user!
  def index
    @per_page = params[:per_page] || Product.per_page || 20
    @q = Product.ransack(params[:q])
    @products = @q.result.by_store(current_store.id).paginate(:page => params[:page], :per_page => @per_page)

    respond_to do |format|
      format.html {}
      format.json {
        render json: @products, each_serializer: ProductSerializer
      }
    end
  end

  def new
    @product = Product.new
    @product_groups = ProductGroup.by_store(current_store.id)
    @product_group_options = []
    @product_groups.walk_tree do |group, level|
      @product_group_options << ["#{'--' * level} #{group.name}", group.id]
    end

    @producers = Producer.by_store(current_store.id)
  end

  def show

  end
  
  def create
    @product = Product.new(product_params)
    @product.user = current_user
    @product.store = current_store
    @product.abbr_name = @product.name.to_s.split.map(&:first).join.downcase
    if @product.save
      @product.code = build_code unless @product.code.present?
      @product.save
      if params[:kind].eql?('save')
        redirect_to products_path, notice: t(:notice_create_product_successfully)
      elsif params[:kind].eql?('cont')
        redirect_to new_producer_path, notice: t(:notice_create_product_successfully)
      end
    end
  end

  def edit
    @product_groups = ProductGroup.by_store(current_store.id)
    @product_group_options = []
    @product_groups.walk_tree do |group, level|
      @product_group_options << ["#{'--' * level} #{group.name}", group.id]
    end

    @producers = Producer.by_store(current_store.id)
  end

  def update_status
    @product.status = params[:status]
    @product.save
  end

  def update
    @product.code = build_code unless params[:product][:code].present?
    if @product.update(product_params)
      redirect_to products_path, notice: t(:notice_update_product_successfully)
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path, notice: t(:notice_delete_product_successfully)
    end
  end

  private

  def build_code
    "HH"+ @product.id.to_s.rjust(6, '0')
  end

  def product_params
    params.require(:product).permit(:name, :code, :description, :note, :cost_price, :sale_price, :vat, :in_stock, :in_stock_min, :in_stock_max, :producer_id, :product_group_id, images: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
