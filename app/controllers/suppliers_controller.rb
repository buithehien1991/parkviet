class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    unless has_permission?("supplier_view")
      render "roles/no_permission", layout: 'home'
      return
    end

    @per_page = params[:per_page] || Product.per_page || 20
    @q = Supplier.ransack(params[:q])
    @suppliers = @q.result.by_store(current_store.id).paginate(:page => params[:page], :per_page => @per_page)

    respond_to do |format|
      format.html {}
      format.json {
        render json: @suppliers, each_serializer: SupplierSerializer
      }
    end
  end

  def show
    unless has_permission?("supplier_view")
      render "roles/no_permission", layout: 'home'
    end
  end

  def new
    unless has_permission?("supplier_new")
      render "roles/no_permission", layout: 'home'
      return
    end

    @supplier = Supplier.new
  end

  def edit
    unless has_permission?("supplier_edit")
      render "roles/no_permission", layout: 'home'
      return
    end
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

      if params[:from].present? && params[:from].eql?('purchase')
        render "purchases/create_supplier"
      else
        redirect_to suppliers_path, notice: t(:notice_create_supplier_successfully)
      end
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
    unless has_permission?("supplier_delete")
      render "roles/no_permission", layout: 'home'
      return
    end

    @supplier.status = :archived
    if @supplier.save
      redirect_to suppliers_path
    end
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
