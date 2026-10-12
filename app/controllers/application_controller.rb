class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  include Pagy::Method
  include ReactLayout
  include Breadcrumbable

  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  inertia_share flash: -> {
    flash.to_hash.slice("notice", "alert").symbolize_keys
  }

  inertia_share auth: -> {
    {
      user: current_user&.slice("id", "email", "name", "username", "role", "status")
    }
  }

  def after_sign_in_path_for(_resource)
    manage_path
  end

  def after_sign_up_path_for(_resource)
    new_store_path
  end

  def authenticate_admin!
    authorize! :manage, :admin
  end

  private

  def handle_access_denied
    redirect_to(user_signed_in? ? root_path : new_user_session_path)
  end

  def google_oauth_enabled?
    ENV["GOOGLE_OAUTH_CLIENT_ID"].present? && ENV["GOOGLE_OAUTH_CLIENT_SECRET"].present?
  end
end
