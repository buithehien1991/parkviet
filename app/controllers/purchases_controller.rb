class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index
    @per_page = params[:per_page] || Purchase.per_page || 20
    @q = Purchase.ransack(params[:q])
    @purchases = @q.result.by_store(current_store.id).paginate(:page => params[:page], :per_page => @per_page)
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
    @purchase.product_purchases.build
  end

  # POST /purchases
  # POST /purchases.json
  def create
    # Remove template row data
    params[:purchase][:product_purchases_attributes].shift if params[:purchase].present? && params[:purchase][:product_purchases_attributes].present?

    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    @purchase.purchaser = current_user
    @purchase.store = current_store

    respond_to do |format|
      if @purchase.save

        @purchase.code = build_code("PO", @purchase) unless @purchase.code.present?
        @purchase.save

        @purchase.product_purchases.each do |pp|
          pp.final_price = pp.quantity * pp.unit_price - pp.discount_money
          pp.save
        end

        format.html { redirect_to @purchase, notice: 'Tạo đơn nhập hàng thành công.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:name, product_purchases_attributes: [:product_id, :purchase_id, :quantity, :unit_price, :discount_percent, :discount_money, :final_price])
    end
end
