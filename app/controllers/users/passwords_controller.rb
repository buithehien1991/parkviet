# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout "application"
  react_layout "fullscreen"

  # GET /resource/password/new
  def new
    self.resource = resource_class.new

    render_forgot_password_page
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      render_forgot_password_page(status: :unprocessable_entity)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]

    render_reset_password_page
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if resource.active_for_authentication? && Devise.sign_in_after_reset_password
        sign_in(resource_name, resource)
        set_flash_message!(:notice, :updated) if is_flashing_format?
      else
        set_flash_message!(:notice, :updated_not_active) if is_flashing_format?
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      render_reset_password_page(status: :unprocessable_entity)
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  private

  def render_forgot_password_page(status: :ok)
    page_title "Forgot password"

    props = {
      email: resource.email,
      can_register: devise_mapping.registerable?,
      can_sign_in: true
    }

    if resource.errors.any?
      props[:errors] = resource.errors.to_hash(true).transform_values { |messages| messages.first }
    end

    render inertia: "Auth/ForgotPassword", props:, status: status
  end

  def render_reset_password_page(status: :ok)
    page_title "Reset password"

    props = {
      reset_password_token: resource.reset_password_token,
      minimum_password_length: @minimum_password_length,
      can_sign_in: true
    }

    if resource.errors.any?
      props[:errors] = resource.errors.to_hash(true).transform_values { |messages| messages.first }
    end

    render inertia: "Auth/ResetPassword", props:, status: status
  end
end
