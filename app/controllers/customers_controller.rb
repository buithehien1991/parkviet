class CustomersController < ApplicationController
  before_action :set_producer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index

  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
  end

  def destroy
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name)
  end
end
