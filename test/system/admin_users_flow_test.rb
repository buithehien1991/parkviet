require "application_system_test_case"

class AdminUsersFlowTest < ApplicationSystemTestCase
  test "admin manages users from the admin interface" do
    login_as_admin

    visit admin_root_path
    assert_current_path admin_root_path
    assert_selector "script[data-page]", visible: :all, text: "Admin/Dashboard/Index"

    click_link "Users"
    assert_current_path admin_users_path
    assert_selector "script[data-page]", visible: :all, text: "member@example.com"

    click_link "Create user"
    fill_in "Email", with: "browser-user@example.com"
    fill_in "Name", with: "Browser User"
    fill_in "Username", with: "browser_user"
    fill_in "Password", with: "password123"
    fill_in "Confirm password", with: "password123"
    click_button "Create user"

    assert_current_path admin_users_path
    assert_selector "tr", text: "browser-user@example.com"

    visit edit_admin_user_path(User.find_by!(email: "browser-user@example.com"))
    fill_in "Name", with: "Browser User Updated"
    click_button "Save changes"

    assert_current_path admin_users_path
    assert_selector "tr", text: "Browser User Updated"

    User.find_by!(email: "browser-user@example.com").destroy!
    visit admin_users_path

    assert_current_path admin_users_path
    assert_no_text "Browser User Updated"
  end

  private

  def login_as_admin
    visit new_user_session_path
    fill_in "Email", with: users(:admin).email
    fill_in "Password", with: "password123"
    click_button "Log in"
    assert_current_path new_store_path
  end
end
