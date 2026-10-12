# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  FAILURE_REASONS = {
    access_denied: "Access denied",
    invalid_credentials: "Invalid credentials",
    timeout: "Authentication timed out"
  }.freeze

  def google_oauth2
    result = User.from_google_oauth(request.env["omniauth.auth"])

    if result.success?
      set_flash_message!(:notice, :signed_in)
      sign_in_and_redirect result.user, event: :authentication
    else
      redirect_to new_user_session_path, alert: result.error, status: :see_other
    end
  rescue StandardError
    redirect_to new_user_session_path, alert: "Google sign in failed.", status: :see_other
  end

  def failure
    message = failure_message

    redirect_to new_user_session_path, alert: "Google sign in failed: #{message}.", status: :see_other
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  private

  def failure_message
    reason_key = request.env["omniauth.error.type"]
    return FAILURE_REASONS[reason_key] if FAILURE_REASONS.key?(reason_key)

    request.env["omniauth.error"]&.message.presence || "Authentication failed"
  end
end
