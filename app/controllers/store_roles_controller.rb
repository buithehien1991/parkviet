class StoreRolesController < StoreController
  before_action :require_owner!

  def index
    render inertia: "workspace/role-index", props: { roles: current_store.store_roles.order(:id).as_json(only: [ :id, :name, :permissions ]) }
  end

  def new
    render_form(current_store.store_roles.new(permissions: StoreRole.default_permissions))
  end

  def edit
    render_form(current_store.store_roles.find(params[:id]))
  end

  def create
    save_role(current_store.store_roles.new(role_params))
  end

  def update
    role = current_store.store_roles.find(params[:id])
    role.assign_attributes(role_params)
    save_role(role)
  end

  def destroy
    role = current_store.store_roles.find(params[:id])
    if role.destroy
      redirect_to store_roles_path, notice: "Đã xóa vai trò."
    else
      redirect_to store_roles_path, alert: role.errors.full_messages.to_sentence
    end
  end

  private

  def require_owner!
    head :forbidden unless owner?
  end

  def role_params
    params.require(:role).permit(:name, permissions: [])
  end

  def save_role(role)
    if role.save
      redirect_to store_roles_path, notice: "Đã lưu vai trò."
    else
      render_form(role, status: :unprocessable_content)
    end
  end

  def render_form(role, status: :ok)
    render inertia: "workspace/role-form", props: { role: role.as_json(only: [ :id, :name, :permissions ]), permissions: StoreRole.all_permissions, errors: role.errors.to_hash(true).transform_values(&:first) }, status:
  end
end
