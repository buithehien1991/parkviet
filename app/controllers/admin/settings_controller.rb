# frozen_string_literal: true

class Admin::SettingsController < Admin::BaseController
  def profile
    set_settings_page_metadata("Profile settings", "Profile")
    render_settings_page("Admin/Settings/Profile")
  end

  def account
    set_settings_page_metadata("Account settings", "Account")
    render_settings_page("Admin/Settings/Account")
  end

  def appearance
    set_settings_page_metadata("Appearance settings", "Appearance")
    render_settings_page("Admin/Settings/Appearance")
  end

  def notifications
    set_settings_page_metadata("Notification settings", "Notifications")
    render_settings_page("Admin/Settings/Notifications")
  end

  def update_profile
    set_settings_page_metadata("Profile settings", "Profile")

    if current_user.update(profile_params)
      redirect_to admin_settings_profile_path, notice: "Profile updated."
    else
      render_settings_page("Admin/Settings/Profile",
                          status: :unprocessable_entity,
                          errors: form_errors(current_user))
    end
  end

  def update_account
    set_settings_page_metadata("Account settings", "Account")

    if current_user.update(account_params)
      redirect_to admin_settings_account_path, notice: "Account updated."
    else
      render_settings_page("Admin/Settings/Account",
                          status: :unprocessable_entity,
                          errors: form_errors(current_user))
    end
  end

  def update_appearance
    set_settings_page_metadata("Appearance settings", "Appearance")

    if current_user.update(appearance_params)
      redirect_to admin_settings_appearance_path, notice: "Appearance updated."
    else
      render_settings_page("Admin/Settings/Appearance",
                          status: :unprocessable_entity,
                          errors: form_errors(current_user))
    end
  end

  def update_notifications
    set_settings_page_metadata("Notification settings", "Notifications")

    if current_user.update(notifications_params)
      redirect_to admin_settings_notifications_path, notice: "Notifications updated."
    else
      render_settings_page("Admin/Settings/Notifications",
                          status: :unprocessable_entity,
                          errors: form_errors(current_user))
    end
  end

  private

  def profile_params
    params.expect(user: %i[name username avatar])
  end

  def account_params
    params.expect(user: %i[name email])
  end

  def appearance_params
    params.expect(user: %i[theme])
  end

  NOTIFICATION_BOOLEAN_KEYS = %i[
    notify_communication_emails
    notify_marketing_emails
    notify_social_emails
    notify_security_emails
    notify_mobile_push
  ].freeze

  def notifications_params
    attrs = params.expect(user: [ :notification_type, *NOTIFICATION_BOOLEAN_KEYS ])
    NOTIFICATION_BOOLEAN_KEYS.each do |key|
      next unless attrs.key?(key)

      attrs[key] = ActiveModel::Type::Boolean.new.cast(attrs[key])
    end
    attrs
  end

  def render_settings_page(component, status: :ok, errors: {})
    render inertia: component, props: settings_props(errors: errors), status: status
  end

  def settings_props(errors: {})
    {
      user: settings_user_props,
      settings: settings_payload,
      errors: errors
    }
  end

  def settings_user_props
    {
      id: current_user.id,
      email: current_user.email.to_s,
      name: current_user.name.to_s,
      username: current_user.username.to_s,
      avatar_url: current_user.avatar.url
    }
  end

  def settings_payload
    (current_user.settings || {}).symbolize_keys
  end

  def form_errors(record)
    record.errors.to_hash(true).transform_values(&:first)
  end

  def set_settings_page_metadata(title, label)
    page_title title
    apply_admin_breadcrumbs([ "Settings", admin_settings_profile_path ], [ label ])
  end
end
