class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @suppliers = Supplier.by_store(current_store.id)
  end

  def new
    @supplier = Supplier.new
  end

  def edit

  end

  def search

  end

  def create
    @supplier = Supplier.new(supplier_params)
    @supplier.birthday = build_birthday(params)
    @supplier.user = current_user
    @supplier.store = current_store
    @supplier.abbr_name = @supplier.name.to_s.split.map(&:first).join.downcase
    if @supplier.save
      @supplier.code = build_supplier_code unless @supplier.code.present?
      @supplier.save
      redirect_to suppliers_path, notice: t(:notice_create_supplier_successfully)
    end
  end

  def update
    @supplier.code = build_supplier_code unless params[:supplier][:code].present?
    @supplier.birthday = build_birthday(params)
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: t(:notice_update_supplier_successfully)
    end
  end

  def destroy
    @supplier.destroy
  end

  private
  def build_supplier_code
    "NCC"+ @supplier.id.to_s.rjust(6, '0')
  end

  def build_birthday(params)
    if params[:supplier]["birthday(1i)"].present? && params[:supplier]["birthday(2i)"].present? && params[:supplier]["birthday(3i)"].present?
      Date.new(params[:supplier]["birthday(1i)"].to_i,params[:supplier]["birthday(2i)"].to_i,params[:supplier]["birthday(3i)"].to_i)
    end
  end

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :supplier_type, :code, :phone, :email, :birthday, :company_name, :address, :province_id, :district_id, :commune_id, :tax, :description)
  end
end
