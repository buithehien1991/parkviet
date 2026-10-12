# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "application"
  react_layout "fullscreen"

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource
    yield resource if block_given?

    render_register_page
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      render_register_page(status: :unprocessable_entity)
    end
  end

  # GET /resource/edit
  def edit
    render_edit_page
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send("current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length

      render_edit_page(status: :unprocessable_entity)
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  private

  def render_register_page(status: :ok)
    page_title "Sign up"

    props = {
      email: resource.email,
      minimum_password_length: @minimum_password_length,
      csrf_token: form_authenticity_token,
      google_oauth_enabled: google_oauth_enabled?
    }

    if resource.errors.any?
      props[:errors] = resource.errors.to_hash(true).transform_values { |messages| messages.first }
    end

    render inertia: "Auth/Register", props:, status: status
  end

  def render_edit_page(status: :ok)
    page_title "Edit account"

    props = {
      email: resource.email,
      minimum_password_length: @minimum_password_length,
      pending_reconfirmation: devise_mapping.confirmable? && resource.pending_reconfirmation?,
      unconfirmed_email: resource.respond_to?(:unconfirmed_email) ? resource.unconfirmed_email : nil
    }

    if resource.errors.any?
      props[:errors] = resource.errors.to_hash(true).transform_values { |messages| messages.first }
    end

    render inertia: "Auth/EditRegistration", props:, status: status
  end

  def inertia_errors
    resource.errors.to_hash(true).transform_values(&:first)
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
