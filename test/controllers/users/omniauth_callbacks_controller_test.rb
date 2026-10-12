require "test_helper"

class Users::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "google oauth callback signs in existing linked user" do
    user = users(:member)
    user.update!(provider: "google_oauth2", uid: "google-123")

    get "/users/auth/google_oauth2/callback", env: {
      "omniauth.auth" => OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "google-123",
        info: {
          email: user.email,
          email_verified: true,
          name: user.name
        }
      )
    }

    assert_redirected_to manage_path

    get edit_user_registration_path
    assert_response :success
  end

  test "google oauth callback creates a new verified user" do
    assert_difference("User.count", 1) do
      get "/users/auth/google_oauth2/callback", env: {
        "omniauth.auth" => OmniAuth::AuthHash.new(
          provider: "google_oauth2",
          uid: "google-new-user",
          info: {
            email: "google-new@example.com",
            email_verified: true,
            name: "Google New User"
          }
        )
      }
    end

    assert_redirected_to manage_path
    user = User.find_by!(email: "google-new@example.com")
    assert_equal "google_oauth2", user.provider
    assert_equal "google-new-user", user.uid
  end

  test "google oauth callback rejects existing local email users" do
    assert_no_difference("User.count") do
      get "/users/auth/google_oauth2/callback", env: {
        "omniauth.auth" => OmniAuth::AuthHash.new(
          provider: "google_oauth2",
          uid: "google-existing-email",
          info: {
            email: users(:member).email,
            email_verified: true,
            name: users(:member).name
          }
        )
      }
    end

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_includes response.body, "An account with this email already exists. Sign in with your password instead."
  end

  test "google oauth callback rejects inactive linked users" do
    user = users(:member)
    user.update!(provider: "google_oauth2", uid: "google-inactive", status: :inactive)

    get "/users/auth/google_oauth2/callback", env: {
      "omniauth.auth" => OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "google-inactive",
        info: {
          email: user.email,
          email_verified: true,
          name: user.name
        }
      )
    }

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_includes response.body, "Your account is inactive."
  end

  test "google oauth callback rejects unverified email" do
    assert_no_difference("User.count") do
      get "/users/auth/google_oauth2/callback", env: {
        "omniauth.auth" => OmniAuth::AuthHash.new(
          provider: "google_oauth2",
          uid: "google-unverified",
          info: {
            email: "google-unverified@example.com",
            email_verified: false,
            name: "Google Unverified"
          }
        )
      }
    end

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_includes response.body, "Google account must have a verified email address."
  end

  test "google oauth failure redirects to login with alert" do
    get "/users/auth/failure", env: { "omniauth.error.type" => :access_denied }

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_includes response.body, "Google sign in failed: Access denied."
  end
end
