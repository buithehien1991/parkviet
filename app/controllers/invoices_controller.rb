class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  protect_from_forgery :except => [:create]

  # GET /invoices
  # GET /invoices.json
  def index
    @per_page = params[:per_page] || Invoice.per_page || 20
    @q = Invoice.ransack(params[:q])
    @invoices = @q.result.by_store(current_store.id).active.order('id desc').paginate(:page => params[:page], :per_page => @per_page)
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json {
        render json: @invoice, serializer: InvoiceSerializer
      }
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.user = current_user
    @invoice.seller = current_user unless params[:invoice][:seller_id].present?
    @invoice.store = current_store

    @invoice.date = Date.today
    @invoice.time = Time.now

    respond_to do |format|
      if @invoice.save
        @invoice.code = build_code("HD", @invoice)

        params[:invoice][:orderProducts].each do |product|
          pi = ProductInvoice.new
          pi.invoice = @invoice
          pi.product_id = product['id']
          pi.quantity = product['quantity']
          pi.unit_price = product['sale_price']
          pi.discount_percent = product['discount_percent']
          pi.discount_money = product['discount_money']
          pi.final_price = product['final_price']
          pi.save
        end if params[:invoice].present? && params[:invoice][:orderProducts].present?
        @invoice.update_price
        @invoice.status = :completed
        @invoice.save

        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, serializer: InvoiceSerializer }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    # @invoice.destroy
    @invoice.status = :canceled
    @invoice.save
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:name, :total_price, :sale_off, :paid, :given_money, :returned_money, :note)
    end
end
