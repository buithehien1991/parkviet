# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  include PagyMetadata

  before_action :set_user, only: %i[edit update destroy]

  def index
    page_title "Users"
    apply_admin_breadcrumbs([ "Users" ])

    search_params = user_search_params
    search = User.order(created_at: :desc, id: :desc).ransack(ransack_user_search_params(search_params))
    users = search.result

    pagy, records = pagy(:offset, users, limit: 10)

    render inertia: "Admin/Users/Index", props: {
      users: records.map { |user| user_row(user) },
      filters: { q: search_params },
      overview: users_overview(users),
      pagination: pagy_metadata(pagy),
      role_options: role_record_options,
      status_options: enum_options(User.statuses)
    }
  end

  def new
    page_title "Create User"
    apply_admin_breadcrumbs([ "Users", admin_users_path ], [ "Create User" ])

    render inertia: "Admin/Users/New", props: {
      user: user_form_defaults,
      role_options: role_record_options,
      status_options: enum_options(User.statuses)
    }
  end

  def create
    page_title "Create User"
    apply_admin_breadcrumbs([ "Users", admin_users_path ], [ "Create User" ])

    user = User.new(create_user_params)

    if user.save
      redirect_to admin_users_path, notice: "User created successfully."
    else
      render_user_form("Admin/Users/New", user, status: :unprocessable_entity)
    end
  end

  def edit
    page_title "Edit User"
    apply_admin_breadcrumbs([ "Users", admin_users_path ], [ "Edit User" ])

    render inertia: "Admin/Users/Edit", props: {
      user: user_form_defaults(@user),
      role_options: role_record_options,
      status_options: enum_options(User.statuses)
    }
  end

  def update
    if demoting_or_deactivating_current_admin?
      redirect_to admin_users_path(q: user_search_params), alert: "You cannot remove your own admin access."
      return
    end

    if @user.update(update_user_params)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      render_user_form("Admin/Users/Edit", @user, status: :unprocessable_entity)
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path(q: user_search_params), alert: "You cannot delete your own account."
      return
    end

    @user.destroy!
    redirect_to admin_users_path(q: user_search_params), notice: "User deleted successfully."
  end

  private

  def user_search_params
    params.fetch(:q, {}).permit(:email_or_name_or_username_cont, :role_id_eq, :status_eq).to_h.compact_blank
  end

  def ransack_user_search_params(search_params)
    search_params.merge(
      "status_eq" => User.statuses[search_params["status_eq"]]
    ).compact_blank
  end

  def users_overview(filtered_users)
    {
      total: User.count,
      matching: filtered_users.count,
      active: User.active.count,
      inactive: User.inactive.count,
      admins: User.with_admin_access.count
    }
  end

  def set_user
    @user = User.find(params[:id])
  end

  def create_user_params
    params.expect(user: %i[email name username role_id status password password_confirmation])
  end

  def update_user_params
    attrs = params.expect(user: %i[email name username role_id status password password_confirmation])

    if attrs[:password].blank? && attrs[:password_confirmation].blank?
      attrs.except(:password, :password_confirmation)
    else
      attrs
    end
  end

  def demoting_or_deactivating_current_admin?
    return false unless @user == current_user

    attrs = update_user_params
    demoting_current_admin?(attrs) || deactivating_current_admin?(attrs)
  end

  def demoting_current_admin?(attrs)
    return false if attrs[:role_id].blank?

    role = Role.find_by(id: attrs[:role_id])
    !(role&.admin? || role&.grants?("Admin", "manage"))
  end

  def deactivating_current_admin?(attrs)
    attrs[:status].present? && attrs[:status] != "active"
  end

  def render_user_form(component, user, status: :ok)
    render inertia: component, props: {
      user: user_form_defaults(user),
      role_options: role_record_options,
      status_options: enum_options(User.statuses),
      errors: user.errors.to_hash(true).transform_values { |messages| messages.first }
    }, status:
  end

  def user_row(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      username: user.username,
      role: user.role_record&.name || user.role,
      role_key: user.role_record&.key || user.role,
      status: user.status,
      created_at: user.created_at.to_date.iso8601
    }
  end

  def user_form_defaults(user = User.new)
    {
      id: user.id,
      email: user.email.to_s,
      name: user.name.to_s,
      username: user.username.to_s,
      role: user.role || User.roles.keys.first,
      role_id: (user.role_id || Role.find_by(key: user.role || "user")&.id || Role.find_by(key: "user")&.id).to_s,
      status: user.status || User.statuses.keys.first
    }
  end

  def enum_options(enum_hash)
    enum_hash.keys.map { |value| { value:, label: value.humanize } }
  end

  def role_record_options
    Role.ordered.map { |role| { value: role.id.to_s, label: role.name } }
  end
end
