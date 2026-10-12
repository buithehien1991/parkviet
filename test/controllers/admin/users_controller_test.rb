require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects guests away from admin users" do
    get admin_users_path

    assert_redirected_to new_user_session_path
  end

  test "redirects non admins away from admin users" do
    sign_in users(:member)

    get admin_users_path

    assert_redirected_to root_path
  end

  test "lists users for admins" do
    sign_in users(:admin)

    get admin_users_path

    assert_response :success
    assert_includes response.body, "Admin/Users/Index"
    assert_includes response.body, users(:member).email
    assert_includes response.body, '"react_layout":"admin"'
    assert_includes response.body, '"page_title":"Users"'
    assert_includes response.body, '"breadcrumbs":[{"label":"Admin","href":"/admin"},{"label":"Users","href":null}]'
  end

  test "renders new page for admins" do
    sign_in users(:admin)

    get new_admin_user_path

    assert_response :success
    assert_includes response.body, "Admin/Users/New"
    assert_includes response.body, '"role_options"'
    assert_includes response.body, '"page_title":"Create User"'
  end

  test "renders edit page for admins" do
    sign_in users(:admin)

    get edit_admin_user_path(users(:member))

    assert_response :success
    assert_includes response.body, "Admin/Users/Edit"
    assert_includes response.body, users(:member).email
    assert_includes response.body, '"page_title":"Edit User"'
  end

  test "filters users by ransack query" do
    sign_in users(:admin)

    get admin_users_path, params: { q: { email_or_name_or_username_cont: "editor" } }

    assert_response :success
    assert_includes response.body, users(:editor).email
    assert_not_includes response.body, users(:member).email
  end

  test "filters users by ransack role and status" do
    sign_in users(:admin)

    get admin_users_path, params: { q: { role_id_eq: roles(:user).id.to_s, status_eq: "inactive" } }

    assert_response :success
    assert_includes response.body, users(:editor).email
    assert_not_includes response.body, users(:member).email
  end

  test "creates user with valid params" do
    sign_in users(:admin)

    assert_difference("User.count", 1) do
      post admin_users_path, params: {
        user: {
          email: "new-user@example.com",
          name: "New User",
          username: "new_user",
          role_id: roles(:user).id,
          status: "active",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to admin_users_path
    assert_equal "new-user@example.com", User.order(:created_at).last.uid
  end

  test "re-renders new page on invalid create" do
    sign_in users(:admin)

    assert_no_difference("User.count") do
      post admin_users_path, params: {
        user: {
          email: "",
          name: "",
          username: "",
          role_id: roles(:user).id,
          status: "active",
          password: "short",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "Admin/Users/New"
    assert_includes response.body, '"errors":{"email":"Email can\'t be blank"'
  end

  test "updates user without password change" do
    sign_in users(:admin)
    original_password = users(:member).encrypted_password

    patch admin_user_path(users(:member)), params: {
      user: {
        email: users(:member).email,
        name: "Updated Member",
        username: users(:member).username,
        role_id: roles(:admin).id,
        status: "inactive",
        password: "",
        password_confirmation: ""
      }
    }

    assert_redirected_to admin_users_path
    users(:member).reload
    assert_equal "Updated Member", users(:member).name
    assert_equal roles(:admin), users(:member).role_record
    assert_equal "admin", users(:member).role
    assert_equal "inactive", users(:member).status
    assert_equal original_password, users(:member).encrypted_password
  end

  test "re-renders edit page on invalid update" do
    sign_in users(:admin)

    patch admin_user_path(users(:member)), params: {
      user: {
        email: "",
        name: users(:member).name,
        username: users(:member).username,
        role_id: users(:member).role_id,
        status: users(:member).status,
        password: "",
        password_confirmation: ""
      }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "Admin/Users/Edit"
    assert_includes response.body, '"errors":{"email":"Email can\'t be blank"'
  end

  test "prevents current admin from removing their own admin access" do
    sign_in users(:admin)

    patch admin_user_path(users(:admin)), params: {
      user: {
        email: users(:admin).email,
        name: users(:admin).name,
        username: users(:admin).username,
        role_id: roles(:user).id,
        status: "active",
        password: "",
        password_confirmation: ""
      }
    }

    assert_redirected_to admin_users_path
    users(:admin).reload
    assert_equal "admin", users(:admin).role
  end

  test "prevents current admin from deactivating their own account" do
    sign_in users(:admin)

    patch admin_user_path(users(:admin)), params: {
      user: {
        email: users(:admin).email,
        name: users(:admin).name,
        username: users(:admin).username,
        role_id: roles(:admin).id,
        status: "inactive",
        password: "",
        password_confirmation: ""
      }
    }

    assert_redirected_to admin_users_path
    users(:admin).reload
    assert_equal "active", users(:admin).status
  end

  test "prevents deleting current admin" do
    sign_in users(:admin)

    assert_no_difference("User.count") do
      delete admin_user_path(users(:admin))
    end

    assert_redirected_to admin_users_path
  end

  test "deletes another user" do
    sign_in users(:admin)

    assert_difference("User.count", -1) do
      delete admin_user_path(users(:editor))
    end

    assert_redirected_to admin_users_path
  end

  test "preserves filters after deleting another user" do
    sign_in users(:admin)

    assert_difference("User.count", -1) do
      delete admin_user_path(users(:editor)), params: { q: { role_id_eq: roles(:user).id.to_s } }
    end

    assert_redirected_to admin_users_path(q: { role_id_eq: roles(:user).id.to_s })
  end
end
