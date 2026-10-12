class StoreController < InertiaController
  before_action :authenticate_user!
  before_action :require_store!
  react_layout "workspace"

  inertia_share store: -> { current_store&.as_json(only: [ :id, :name ]) }
  inertia_share stores: -> { accessible_stores.map { |store| store.as_json(only: [ :id, :name ]) } }
  inertia_share store_permissions: -> { owner? ? StoreRole.all_permissions : current_member&.store_role&.permissions || [] }

  rescue_from DocumentWorkflow::InvalidTransition, with: :workflow_error

  private

  def accessible_stores
    @accessible_stores ||= Store.where(user_id: current_user.id)
      .or(Store.where(id: current_user.members.where(active: true).select(:store_id))).order(:id).to_a
  end

  def current_store
    @current_store ||= accessible_stores.find { |store| store.id == session[:store_id].to_i } || accessible_stores.first
  end

  def current_member
    @current_member ||= current_store&.members&.includes(:store_role)&.find_by(user: current_user, active: true)
  end

  def owner?
    current_store&.user_id == current_user&.id
  end

  def permit_store!(permission)
    head :forbidden unless owner? || current_member&.store_role&.permissions&.include?(permission)
  end

  def require_store!
    redirect_to new_store_path unless current_store
  end

  def workflow_error(error)
    redirect_back fallback_location: manage_path, alert: error.message, inertia: { errors: { base: error.message } }
  end
end
