class CustomersController < ApplicationController
  before_action :set_producer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @customers = Customer.by_store(current_store.id)
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.user = current_user
    @customer.store = current_store
    @customer.abbr_name = @customer.name.to_s.split.map(&:first).join.downcase
    if @customer.save
      @customer.code = "KH"+ @customer.id.to_s.rjust(6, '0') unless @customer.code.present?
      @customer.save
      redirect_to customers_path, notice: "Tạo khách hàng thành công."
    end
  end

  def destroy
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :type, :code, :phone, :email, :birthday, :sex, :company_name, :address, :province_id, :district_id, :commune_id, :tax, :description)
  end
end
