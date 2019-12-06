class ProductPurchaseOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product_purchase_order, only: [:show, :edit, :update, :destroy]

  # GET /product_purchase_orders
  # GET /product_purchase_orders.json
  def index
    @product_purchase_orders = ProductPurchaseOrder.all
  end

  # GET /product_purchase_orders/1
  # GET /product_purchase_orders/1.json
  def show
  end

  # GET /product_purchase_orders/new
  def new
    @product_purchase_order = ProductPurchaseOrder.new
    if params[:purchase_order_id].present? && PurchaseOrder.where(id: params[:purchase_order_id]).first.present?
      @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    else
      @error = true
    end
  end

  # GET /product_purchase_orders/1/edit
  def edit
    @purchase_order = @product_purchase_order.purchase_order
  end

  # POST /product_purchase_orders
  # POST /product_purchase_orders.json
  def create
    @product_purchase_order = ProductPurchaseOrder.new(product_purchase_order_params)

    respond_to do |format|
      if @product_purchase_order.save
        format.html { redirect_to @product_purchase_order.purchase_order, notice: 'Product purchase order was successfully created.' }
        format.json { render :show, status: :created, location: @product_purchase_order }
      else
        format.html { render :new }
        format.json { render json: @product_purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_purchase_orders/1
  # PATCH/PUT /product_purchase_orders/1.json
  def update
    respond_to do |format|
      if @product_purchase_order.update(product_purchase_order_params)
        format.html { redirect_to @product_purchase_order.purchase_order, notice: 'Product purchase order was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_purchase_order }
      else
        format.html { render :edit }
        format.json { render json: @product_purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_purchase_orders/1
  # DELETE /product_purchase_orders/1.json
  def destroy
    @product_purchase_order.destroy
    respond_to do |format|
      format.html { redirect_to @product_purchase_order.purchase_order, notice: 'Product purchase order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_purchase_order
      @product_purchase_order = ProductPurchaseOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_purchase_order_params
      params.require(:product_purchase_order).permit(:product_id, :purchase_order_id, :quantity, :unit_price, :supplier_id)
    end
end
