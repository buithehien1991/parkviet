require "test_helper"
require "base64"
require "tempfile"

class UserTest < ActiveSupport::TestCase
  test "ransack matches email name and username" do
    results = User.ransack(email_or_name_or_username_cont: "editor").result

    assert_includes results, users(:editor)
    assert_not_includes results, users(:member)
  end

  test "ransack exposes only admin-safe attributes" do
    assert_includes User.ransackable_attributes, "email"
    assert_includes User.ransackable_attributes, "role"
    assert_not_includes User.ransackable_attributes, "encrypted_password"
    assert_includes User.ransackable_associations, "role_record"
  end

  test "username length is limited" do
    user = User.new(
      email: "toolong@example.com",
      password: "password123",
      password_confirmation: "password123",
      username: "x" * 33
    )

    assert_not user.valid?
    assert_includes user.errors[:username], "is too long (maximum is 32 characters)"
  end

  test "avatar accepts supported image uploads within size limit" do
    user = User.new(
      email: "avatar-valid-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123",
      role_record: roles(:user)
    )

    with_uploaded_file("avatar.png", "image/png", tiny_png_data) do |file|
      user.avatar = file

      assert user.valid?
    end
  end

  test "avatar rejects unsupported file types" do
    user = User.new(
      email: "avatar-invalid-type-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123",
      role_record: roles(:user)
    )

    with_uploaded_file("avatar.txt", "text/plain", "not an image") do |file|
      user.avatar = file

      assert_not user.valid?
      assert user.errors[:avatar].any?
    end
  end

  test "avatar rejects oversized files" do
    user = User.new(
      email: "avatar-invalid-size-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123",
      role_record: roles(:user)
    )

    with_uploaded_file("avatar.png", "image/png", "0" * (6.megabytes)) do |file|
      user.avatar = file

      assert_not user.valid?
      assert user.errors[:avatar].any?
    end
  end

  test "email provider users sync uid from email" do
    user = User.create!(
      email: "sync@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_equal "email", user.provider
    assert_equal "sync@example.com", user.uid
  end

  test "new users can be created without role record" do
    user = User.create!(
      email: "role-sync@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_nil user.role_record
    assert_equal "user", user.role
    assert_not user.can_manage_admin?
  end

  test "changing role record to admin syncs legacy enum" do
    user = users(:member)

    user.update!(role_record: roles(:admin))

    assert_equal "admin", user.role
    assert user.can_manage_admin?
  end

  test "admin access checks rely on role record permissions" do
    assert users(:admin).can_manage_admin?
    assert_not users(:member).can_manage_admin?
  end

  test "legacy admin enum bootstraps admin access" do
    user = users(:member)

    user.update_column(:role, User.roles.fetch("admin"))

    assert_equal roles(:user), user.role_record
    assert user.can_manage_admin?
  end

  test "with_admin_access includes legacy enum admins without role records" do
    user = User.create!(
      email: "legacy-admin@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :admin
    )

    assert_includes User.with_admin_access, user
  end

  test "admin permission on non-admin role grants admin access" do
    user = users(:member)
    roles(:user).permissions << permissions(:admin_manage)

    assert user.can_manage_admin?
  end

  test "google oauth links existing verified email users" do
    user = User.create!(
      email: "linked-google@example.com",
      password: "password123",
      password_confirmation: "password123",
      provider: "google_oauth2",
      uid: "google-123"
    )
    auth = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "google-123",
      info: {
        email: user.email,
        email_verified: true,
        name: "Member User"
      }
    )

    result = User.from_google_oauth(auth)

    assert result.success?
    assert_equal user, result.user
    user.reload
    assert_equal "google_oauth2", user.provider
    assert_equal "google-123", user.uid
  end

  test "google oauth rejects existing local email users" do
    user = users(:member)
    auth = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "google-789",
      info: {
        email: user.email,
        email_verified: true,
        name: "Member User"
      }
    )

    result = User.from_google_oauth(auth)

    assert_not result.success?
    assert_equal "An account with this email already exists. Sign in with your password instead.", result.error
    user.reload
    assert_equal "email", user.provider
    assert_equal user.email, user.uid
  end

  test "google oauth rejects inactive linked users" do
    user = User.create!(
      email: "inactive-google@example.com",
      password: "password123",
      password_confirmation: "password123",
      provider: "google_oauth2",
      uid: "google-inactive",
      status: :inactive
    )
    auth = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "google-inactive",
      info: {
        email: user.email,
        email_verified: true,
        name: "Inactive User"
      }
    )

    result = User.from_google_oauth(auth)

    assert_not result.success?
    assert_equal "Your account is inactive.", result.error
  end

  test "google oauth rejects unverified emails" do
    auth = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "google-456",
      info: {
        email: "unverified@example.com",
        email_verified: false,
        name: "Unverified User"
      }
    )

    result = User.from_google_oauth(auth)

    assert_not result.success?
    assert_equal "Google account must have a verified email address.", result.error
    assert_not User.exists?(email: "unverified@example.com")
  end

  test "google oauth rejects malformed payloads" do
    auth = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "",
      info: {
        email: "broken@example.com",
        email_verified: true,
        name: "Broken User"
      }
    )

    result = User.from_google_oauth(auth)

    assert_not result.success?
    assert_equal "Google sign in failed.", result.error
  end

  test "inactive users are not active for authentication" do
    user = users(:member)
    user.update!(status: :inactive)

    assert_not user.active_for_authentication?
    assert_equal :inactive, user.inactive_message
  end

  private

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
