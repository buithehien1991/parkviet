require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects guests away from admin dashboard" do
    get admin_root_path

    assert_redirected_to new_user_session_path
  end

  test "redirects non admins away from admin dashboard" do
    sign_in users(:member)

    get admin_root_path

    assert_redirected_to root_path
  end

  test "renders dashboard for admins" do
    sign_in users(:admin)

    get admin_root_path

    assert_response :success
    assert_includes response.body, "Admin/Dashboard/Index"
    assert_includes response.body, '"total_users":3'
    assert_includes response.body, '"active_users":2'
    assert_includes response.body, '"inactive_users":1'
    assert_includes response.body, '"recent_users"'
    assert_includes response.body, '"status_breakdown"'
    assert_includes response.body, '"attention"'
    assert_includes response.body, '"react_layout":"admin"'
    assert_includes response.body, '"page_title":"Admin Dashboard"'
    assert_includes response.body, '"breadcrumbs":[{"label":"Admin","href":"/admin"},{"label":"Dashboard","href":null}]'
  end
end
