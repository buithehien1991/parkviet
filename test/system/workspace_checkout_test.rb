require "application_system_test_case"

class WorkspaceCheckoutTest < ApplicationSystemTestCase
  setup do
    @owner = users(:member)
    @store = Store.create!(user: @owner, name: "Cửa hàng E2E")
    @product = @store.products.create!(user: @owner, name: "Cà phê E2E", sale_price: 30000, in_stock: 5)
  end

  test "owner logs in, creates a partner and checks out a real invoice" do
    visit new_user_session_path
    fill_in "Email", with: @owner.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    assert_text "Tổng quan cửa hàng"

    visit new_customer_path
    fill_in "Tên", with: "Khách E2E"
    click_button "Lưu thay đổi"
    assert_text "Khách E2E"

    visit sale_path
    add_product
    assert_selector "button[aria-label='Xóa Cà phê E2E']"
    fill_in "Tiền khách đưa", with: "50000"
    assert_field "Tiền khách đưa", with: "50000"
    click_button "Thanh toán & tạo hóa đơn"
    assert_text "Cà phê E2E"
    assert_text "Hoàn thành"
    assert_text "20.000"
    assert_equal BigDecimal("4"), @product.reload.in_stock
    assert_equal BigDecimal("30000"), @store.invoices.completed.last.final_price
  end

  test "failed checkout keeps cart and displays inventory error" do
    visit new_user_session_path
    fill_in "Email", with: @owner.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    assert_text "Tổng quan cửa hàng"
    visit sale_path
    add_product
    assert_selector "button[aria-label='Xóa Cà phê E2E']"
    fill_in "Tiền khách đưa", with: "50000"
    assert_field "Tiền khách đưa", with: "50000"
    @product.update!(in_stock: 0)
    click_button "Thanh toán & tạo hóa đơn"
    assert_selector "[role=alert]", text: "tồn kho không đủ"
    assert_current_path sale_path
    assert_selector "button[aria-label='Xóa Cà phê E2E']"
    assert_equal 0, @store.invoices.count
  end

  def add_product
    find("button[aria-label='Thêm Cà phê E2E vào giỏ']:not([disabled])").click
    assert_selector "button[aria-label='Xóa Cà phê E2E']"
  end

  test "workspace fits desktop, tablet and mobile viewports" do
    visit new_user_session_path
    fill_in "Email", with: @owner.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    assert_text "Tổng quan cửa hàng"
    [ 375, 768, 1440 ].each do |width|
      page.driver.browser.manage.window.resize_to(width, 900)
      visit manage_path
      assert_text "Tổng quan cửa hàng"
      assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth"), "Overflow at #{width}px"
      save_screenshot Rails.root.join("tmp/screenshots/workspace-#{width}.png")
    end
  end
end
