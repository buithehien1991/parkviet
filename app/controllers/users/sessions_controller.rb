# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout "application"
  react_layout "fullscreen"

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    render_login_page
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      resource.errors.add(:base, I18n.t("devise.failure.invalid", authentication_keys: "Email"))

      render_login_page(status: :unprocessable_entity)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def render_login_page(status: :ok)
    page_title "Log in"

    props = {
      email: resource.email,
      remember_me: ActiveModel::Type::Boolean.new.cast(resource.remember_me),
      rememberable: devise_mapping.rememberable?,
      can_register: devise_mapping.registerable?,
      can_recover_password: devise_mapping.recoverable?,
      csrf_token: form_authenticity_token,
      google_oauth_enabled: google_oauth_enabled?
    }

    if resource.errors.any?
      props[:errors] = resource.errors.to_hash(true).transform_values { |messages| messages.first }
    end

    render inertia: "Auth/Login", props:, status: status
  end
end
