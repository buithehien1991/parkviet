require "test_helper"

class Users::AuthPagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "renders login page with fullscreen layout metadata" do
    get new_user_session_path

    assert_response :success
    assert_includes response.body, "Auth/Login"
    assert_includes response.body, '"react_layout":"fullscreen"'
    assert_includes response.body, '"page_title":"Log in"'
  end

  test "renders registration page with fullscreen layout metadata" do
    get new_user_registration_path

    assert_response :success
    assert_includes response.body, "Auth/Register"
    assert_includes response.body, '"react_layout":"fullscreen"'
    assert_includes response.body, '"page_title":"Sign up"'
  end

  test "renders forgot password page with fullscreen layout metadata" do
    get new_user_password_path

    assert_response :success
    assert_includes response.body, "Auth/ForgotPassword"
    assert_includes response.body, '"react_layout":"fullscreen"'
    assert_includes response.body, '"page_title":"Forgot password"'
  end

  test "renders edit registration page with fullscreen layout metadata" do
    sign_in users(:admin)

    get edit_user_registration_path

    assert_response :success
    assert_includes response.body, "Auth/EditRegistration"
    assert_includes response.body, '"react_layout":"fullscreen"'
    assert_includes response.body, '"page_title":"Edit account"'
  end
end
