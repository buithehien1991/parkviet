class StoresController < InertiaController
  before_action :authenticate_user!
  react_layout "application"

  def new
    render inertia: "workspace/store-setup", props: { errors: {} }
  end

  def create
    store = current_user.stores.new(params.require(:store).permit(:name, :phone, :address, :tax))
    if store.save
      session[:store_id] = store.id
      redirect_to manage_path, notice: "Đã tạo cửa hàng."
    else
      render inertia: "workspace/store-setup", props: { errors: store.errors.to_hash(true).transform_values(&:first) }, status: :unprocessable_content
    end
  end

  def switch
    store = Store.where(user_id: current_user.id).or(Store.where(id: current_user.members.where(active: true).select(:store_id))).find(params[:id])
    session[:store_id] = store.id
    redirect_to manage_path
  end
end
