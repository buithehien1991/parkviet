class MembersController < StoreController
  before_action :authorize_member!

  def index
    render inertia: "workspace/team-index", props: {
      members: current_store.members.includes(:user, :store_role, :branch).map { |member|
        { id: member.id, name: member.user.name, email: member.user.email, role_name: member.store_role.name, branch_name: member.branch&.name, active: member.active }
      }, can_create: allowed?("new"), can_edit: allowed?("edit"), can_delete: allowed?("delete")
    }
  end

  def new
    render_form(current_store.members.new)
  end

  def edit
    render_form(current_store.members.find(params[:id]))
  end

  def create
    member = current_store.members.new(member_params)
    user = User.new(params.require(:user).permit(:email, :name, :password, :password_confirmation))
    Member.transaction do
      user.save!
      member.user = user
      member.save!
    end
    redirect_to members_path, notice: "Đã thêm nhân viên."
  rescue ActiveRecord::RecordInvalid => error
    member.errors.add(:base, error.record.errors.full_messages.to_sentence)
    render_form(member, status: :unprocessable_content, user:)
  end

  def update
    member = current_store.members.find(params[:id])
    Member.transaction do
      member.update!(member_params)
      if params[:user].present? && editable_profile?(member)
        attributes = params.require(:user).permit(:name, :email, :password, :password_confirmation)
        attributes.except!(:password, :password_confirmation) if attributes[:password].blank?
        member.user.update!(attributes)
      end
    end
    redirect_to members_path, notice: "Đã cập nhật thông tin và phân quyền."
  rescue ActiveRecord::RecordInvalid => error
    member.errors.add(:base, error.record.errors.full_messages.to_sentence)
    render_form(member, status: :unprocessable_content)
  end

  def destroy
    current_store.members.find(params[:id]).update!(active: false)
    redirect_to members_path, notice: "Đã ngừng quyền truy cập cửa hàng."
  end

  private

  def allowed?(action)
    owner? || current_member&.store_role&.permissions&.include?("user_#{action}") || false
  end

  def authorize_member!
    permission = { "index" => "view", "new" => "new", "create" => "new", "edit" => "edit", "update" => "edit", "destroy" => "delete" }.fetch(action_name)
    permit_store!("user_#{permission}")
  end

  def member_params
    params.require(:member).permit(:store_role_id, :branch_id, :active).tap do |attributes|
      attributes[:branch_id] = nil if attributes[:branch_id].blank?
      role = current_store.store_roles.find(attributes[:store_role_id])
      if !owner? && (role.permissions - current_member.store_role.permissions).any?
        raise DocumentWorkflow::InvalidTransition, "Không được cấp quyền cao hơn quyền của bạn."
      end
      current_store.branches.find(attributes[:branch_id]) if attributes[:branch_id].present?
    end
  end

  def editable_profile?(member)
    account = member.user
    account && account != current_user && !account.admin_access? && account.stores.none? &&
      account.members.where.not(store: current_store).none?
  end

  def render_form(member, status: :ok, user: nil)
    render inertia: "workspace/team-form", props: {
      member: member.as_json(only: [ :id, :store_role_id, :branch_id, :active ]),
      user: (user || member.user)&.as_json(only: [ :email, :name ]),
      roles: current_store.store_roles.order(:name).as_json(only: [ :id, :name ]),
      branches: current_store.branches.order(:name).as_json(only: [ :id, :name ]),
      editable_profile: member.new_record? || editable_profile?(member),
      errors: member.errors.to_hash(true).transform_values(&:first)
    }, status:
  end
end
