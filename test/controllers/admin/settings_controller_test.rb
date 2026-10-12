require "test_helper"
require "base64"
require "tempfile"

class Admin::SettingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects guests away from settings" do
    get admin_settings_profile_path

    assert_redirected_to new_user_session_path
  end

  test "redirects non admins away from settings" do
    sign_in users(:member)

    get admin_settings_profile_path

    assert_redirected_to root_path
  end

  test "renders profile page for admin" do
    sign_in users(:admin)

    get admin_settings_profile_path

    assert_response :success
    assert_includes response.body, "Admin/Settings/Profile"
    assert_includes response.body, users(:admin).email
    assert_includes response.body, '"react_layout":"admin"'
    assert_includes response.body, '"page_title":"Profile settings"'
    assert_includes response.body, '"breadcrumbs":[{"label":"Admin","href":"/admin"},{"label":"Settings","href":"/admin/settings/profile"},{"label":"Profile","href":null}]'
  end

  test "renders account page for admin" do
    sign_in users(:admin)

    get admin_settings_account_path

    assert_response :success
    assert_includes response.body, "Admin/Settings/Account"
    assert_includes response.body, '"page_title":"Account settings"'
  end

  test "updates profile fields with valid params" do
    sign_in users(:admin)

    patch admin_settings_profile_path, params: {
      user: { name: "Renamed Admin", username: "renamed_admin" }
    }

    assert_redirected_to admin_settings_profile_path
    users(:admin).reload
    assert_equal "Renamed Admin", users(:admin).name
    assert_equal "renamed_admin", users(:admin).username
  end

  test "updates profile avatar with valid image upload" do
    admin = create_admin_user
    sign_in admin

    with_uploaded_file("avatar.png", "image/png", tiny_png_data) do |file|
      patch admin_settings_profile_path, params: {
        user: { name: admin.name, username: admin.username, avatar: file }
      }

      assert_redirected_to admin_settings_profile_path
    end

    admin.reload
    assert_predicate admin.avatar, :present?
  end

  test "re-renders profile page on invalid avatar upload" do
    admin = create_admin_user
    sign_in admin

    with_uploaded_file("avatar.txt", "text/plain", "not an image") do |file|
      patch admin_settings_profile_path, params: {
        user: { name: admin.name, username: admin.username, avatar: file }
      }

      assert_response :unprocessable_entity
      assert_includes response.body, "Admin/Settings/Profile"
      assert_includes response.body, '"errors"'
    end
  end

  test "re-renders profile page on invalid update" do
    sign_in users(:admin)

    patch admin_settings_profile_path, params: {
      user: { name: "x" * 65, username: users(:admin).username }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "Admin/Settings/Profile"
    assert_includes response.body, '"errors"'
    assert_includes response.body, "is too long"
  end

  test "updates account fields with valid params" do
    sign_in users(:admin)

    patch admin_settings_account_path, params: {
      user: { name: "New Admin Name", email: "new-admin@example.com" }
    }

    assert_redirected_to admin_settings_account_path
    users(:admin).reload
    assert_equal "New Admin Name", users(:admin).name
    assert_equal "new-admin@example.com", users(:admin).email
  end

  test "re-renders account page on invalid update" do
    sign_in users(:admin)

    patch admin_settings_account_path, params: {
      user: { name: users(:admin).name, email: "" }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "Admin/Settings/Account"
    assert_includes response.body, '"errors":{"email":'
  end

  test "profile update only accepts permitted params" do
    sign_in users(:admin)
    original_role = users(:admin).role

    patch admin_settings_profile_path, params: {
      user: { name: "Still Admin", username: users(:admin).username, role: "user" }
    }

    users(:admin).reload
    assert_equal original_role, users(:admin).role
  end

  test "renders appearance page for admin" do
    sign_in users(:admin)

    get admin_settings_appearance_path

    assert_response :success
    assert_includes response.body, "Admin/Settings/Appearance"
  end

  test "renders notifications page for admin" do
    sign_in users(:admin)

    get admin_settings_notifications_path

    assert_response :success
    assert_includes response.body, "Admin/Settings/Notifications"
  end

  test "updates appearance theme with valid value" do
    sign_in users(:admin)

    patch admin_settings_appearance_path, params: { user: { theme: "dark" } }

    assert_redirected_to admin_settings_appearance_path
    users(:admin).reload
    assert_equal "dark", users(:admin).theme
  end

  test "re-renders appearance page on invalid theme" do
    sign_in users(:admin)

    patch admin_settings_appearance_path, params: { user: { theme: "neon" } }

    assert_response :unprocessable_entity
    assert_includes response.body, "Admin/Settings/Appearance"
    assert_includes response.body, '"errors":{"theme":'
  end

  test "updates notification preferences and coerces booleans" do
    sign_in users(:admin)

    patch admin_settings_notifications_path, params: {
      user: {
        notification_type: "mentions",
        notify_communication_emails: "true",
        notify_marketing_emails: "false",
        notify_social_emails: "1",
        notify_security_emails: "true",
        notify_mobile_push: "0"
      }
    }

    assert_redirected_to admin_settings_notifications_path
    users(:admin).reload
    assert_equal "mentions", users(:admin).notification_type
    assert_equal true, users(:admin).notify_communication_emails
    assert_equal false, users(:admin).notify_marketing_emails
    assert_equal true, users(:admin).notify_social_emails
    assert_equal false, users(:admin).notify_mobile_push
  end

  private

  def create_admin_user
    User.create!(
      email: "admin-upload-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123",
      name: "Upload Admin",
      username: "upload_admin_#{SecureRandom.hex(3)}",
      role_record: roles(:admin)
    )
  end

  def with_uploaded_file(filename, content_type, content)
    tempfile = Tempfile.new([ File.basename(filename, ".*"), File.extname(filename) ])
    tempfile.binmode
    tempfile.write(content)
    tempfile.rewind

    yield Rack::Test::UploadedFile.new(tempfile.path, content_type, original_filename: filename)
  ensure
    tempfile.close!
  end

  def tiny_png_data
    Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+yF9kAAAAASUVORK5CYII=")
  end
end
