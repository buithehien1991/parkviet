require "test_helper"

class WorkspaceFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @owner = users(:member)
    @store = Store.create!(user: @owner, name: "Kiểm thử bán hàng")
    @product = @store.products.create!(user: @owner, name: "Gạo", sale_price: 25000, in_stock: 10)
    @other = Store.create!(user: users(:admin), name: "Cửa hàng khác")
    @other_product = @other.products.create!(user: users(:admin), name: "Dữ liệu riêng", sale_price: 12000, in_stock: 10)
    sign_in @owner
  end

  test "all migrated management screens render React pages" do
    %w[/manage /sale /manage/products /manage/customers /manage/suppliers /manage/producers /manage/product_groups /manage/product_types /manage/branches /manage/reports /manage/print_templates /manage/invoices /manage/purchases /manage/purchase_orders /manage/members /manage/store_roles /manage/debts /manage/store_settings/edit].each do |path|
      get path
      assert_response :success, path
      assert_includes response.body, "workspace/", path
    end
  end

  test "record access cannot cross stores" do
    get product_path(@other_product)
    assert_response :not_found
  end

  test "foreign association assignment cannot cross stores" do
    patch product_path(@product), params: { record: { name: "Mới", producer_id: @other.producers.create!(user: users(:admin), name: "Riêng").id } }
    assert_response :unprocessable_content
    assert_nil @product.reload.producer_id
  end

  test "store switch cannot cross membership boundaries" do
    post switch_store_path(@other)
    assert_response :not_found
  end

  test "cashier cannot access admin or increase granted role permissions" do
    employee = users(:admin)
    employee.update!(role: :user, role_record: roles(:user))
    role = @store.store_roles.first
    @store.members.create!(user: employee, store_role: role)
    sign_out @owner
    sign_in employee
    post switch_store_path(@store)
    get sale_path
    assert_response :success
    get new_product_path
    assert_response :forbidden
    get admin_root_path
    assert_redirected_to root_path
    get store_roles_path
    assert_response :forbidden
  end

  test "creating checkout uses authoritative price for cashier" do
    employee = users(:admin)
    role = @store.store_roles.first
    @store.members.create!(user: employee, store_role: role)
    sign_out @owner
    sign_in employee
    post switch_store_path(@store)
    key = SecureRandom.uuid
    payload = { request_key: key, paid: 50000, given_money: 60000, total_price: 1, final_price: 1, lines: [ { product_id: @product.id, quantity: 2, unit_price: 1, discount_money: 0 } ] }
    post invoices_path, params: { document: payload, finalize: true }
    invoice = @store.invoices.find_by!(request_key: key)
    assert_redirected_to invoice_path(invoice)
    assert_equal BigDecimal("50000"), invoice.final_price
    assert_equal BigDecimal("10000"), invoice.returned_money
    assert_equal BigDecimal("8"), @product.reload.in_stock
    assert_no_difference "Invoice.count" do
      post invoices_path, params: { document: payload, finalize: true }
    end
    get invoice_path(invoice)
    assert_response :success
  end

  test "CRUD creates and persists store-scoped records" do
    assert_difference "Customer.count", 1 do
      post customers_path, params: { record: { name: "Khách mới", phone: "0900000000", store_id: @other.id } }
    end
    customer = Customer.order(:id).last
    assert_equal @store.id, customer.store_id
    assert_redirected_to customers_path
    patch customer_path(customer), params: { record: { name: "Khách cập nhật" } }
    assert_equal "Khách cập nhật", customer.reload.name
    delete customer_path(customer)
    assert customer.reload.archived?
  end
end
