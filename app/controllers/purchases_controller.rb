class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index
    unless has_permission?("purchase_view")
      render "roles/no_permission", layout: 'home'
      return
    end

    @per_page = params[:per_page] || Purchase.per_page || 20
    @q = Purchase.ransack(params[:q])
    @purchases = @q.result.by_store(current_store.id).order('id desc').paginate(:page => params[:page], :per_page => @per_page)
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    unless has_permission?("purchase_view")
      render "roles/no_permission", layout: 'home'
    end
  end

  # GET /purchases/new
  def new
    unless has_permission?("purchase_new")
      render "roles/no_permission", layout: 'home'
      return
    end

    @purchase = Purchase.new
    @purchase.date = Date.today
    @purchase.time =  Time.now.strftime('%H:%M') #  Time.now.strftime('%H:%M')
    @users = ([current_user] + current_store.members.map{|m| m.user}).uniq
    @suppliers = Supplier.by_store(current_store.id)

    # Copy data from PPO
    if params[:purchase_order_id].present?
      purchase_order = PurchaseOrder.find(params[:purchase_order_id])
      if purchase_order.store == current_store
        @purchase.purchase_order_id = purchase_order.id
        @purchase.supplier = purchase_order.supplier
        @purchase.user = current_user
        @purchase.purchaser = current_user
        @purchase.store = current_store

        if @purchase.save
          @purchase.code = build_code("PC", @purchase) unless @purchase.code.present?

          purchase_order.product_purchase_orders.each do |ppo|
            pp = ProductPurchase.new
            pp.purchase = @purchase
            pp.product = ppo.product
            pp.quantity = ppo.quantity.present? ? ppo.quantity : 0
            pp.unit_price = ppo.unit_price.present? ? ppo.unit_price : 0
            pp.discount_percent = ppo.discount_percent.present? ? ppo.discount_percent : 0
            pp.discount_money = ppo.discount_money.present? ? ppo.discount_money : 0
            pp.final_price = ppo.total_price
            pp.save
          end

          @purchase.update_price
          @purchase.save
        end
      end
    end
  end

  # GET /purchases/1/edit
  def edit
    unless has_permission?("purchase_edit")
      render "roles/no_permission", layout: 'home'
      return
    end

    @purchase = Purchase.find(params[:id])
    @users = ([current_user] + current_store.members.map{|m| m.user}).uniq
    @suppliers = Supplier.by_store(current_store.id)
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

    if params[:type].eql?("purchase")
      @purchase.status = :purchased
    end

    respond_to do |format|
      if @purchase.save

        @purchase.code = build_code("PC", @purchase) unless @purchase.code.present?

        total = 0
        @purchase.product_purchases.each do |pp|
          final_price = pp.quantity * pp.unit_price - pp.discount_money
          pp.final_price = final_price
          total += final_price
          pp.save
        end

        @purchase.discount_money = 0 if @purchase.discount_money.nil?
        @purchase.paid = 0 if @purchase.paid.nil?
        @purchase.total_price = total
        @purchase.price = total - @purchase.discount_money
        @purchase.dept = @purchase.paid + @purchase.discount_money - total
        @purchase.save

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
    # Remove template row data
    params[:purchase][:product_purchases_attributes].shift if params[:purchase].present? && params[:purchase][:product_purchases_attributes].present?
    new_pps = params[:purchase][:product_purchases_attributes].map{|pp| pp['id'].to_i}

    respond_to do |format|
      if @purchase.update(purchase_params)
        @purchase.product_purchases.each do |pp|
          # Delete removed item or update price
          if new_pps.include?(pp.id)
            pp.final_price = pp.quantity * pp.unit_price - pp.discount_money
            pp.save
          else
            pp.destroy
          end
        end

        total = 0
        @purchase.product_purchases.each do |pp|
          total += pp.final_price
        end
        @purchase.total_price = total
        @purchase.price = total - @purchase.discount_money
        @purchase.dept = @purchase.paid + @purchase.discount_money - total
        @purchase.save

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
    unless has_permission?("purchase_delete")
      render "roles/no_permission", layout: 'home'
      return
    end

    @purchase.status = :cancel
    if @purchase.save
      respond_to do |format|
        format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:name, :purchaser_id, :supplier_id, :code, :discount_money, :paid, :note, :date, :time, :purchase_order_id, product_purchases_attributes: [:id, :product_id, :purchase_id, :quantity, :unit_price, :discount_percent, :discount_money, :final_price])
    end
end
