require "test_helper"

class DocumentWorkflowTest < ActiveSupport::TestCase
  setup do
    @owner = users(:member)
    @store = Store.create!(user: @owner, name: "Cửa hàng kiểm thử")
    @product = @store.products.create!(user: @owner, name: "Sản phẩm", sale_price: "100.25", cost_price: "50.10", in_stock: 10)
  end

  test "computes decimal totals on server and finalizes stock once" do
    invoice = Invoice.new(store: @store, user: @owner)
    attributes = invoice_attributes(quantity: "2.5", discount: "0.10")
    saved = DocumentWorkflow.save!(invoice, attributes, finalize: true)
    assert_equal BigDecimal("250.53"), saved.total_price
    assert_equal BigDecimal("249.53"), saved.final_price
    assert_equal BigDecimal("7.5"), @product.reload.in_stock
    assert saved.completed?
    DocumentWorkflow.transition!(saved, "complete")
    assert_equal BigDecimal("7.5"), @product.reload.in_stock
    DocumentWorkflow.transition!(saved, "cancel")
    assert_equal BigDecimal("10"), @product.reload.in_stock
    DocumentWorkflow.transition!(saved, "cancel")
    assert_equal BigDecimal("10"), @product.reload.in_stock
  end

  test "retries with same request key return the same invoice" do
    attributes = invoice_attributes
    first = DocumentWorkflow.save!(Invoice.new(store: @store, user: @owner), attributes, finalize: true)
    assert_no_difference "Invoice.count" do
      second = DocumentWorkflow.save!(Invoice.new(store: @store, user: @owner), attributes, finalize: true)
      assert_equal first.id, second.id
    end
    assert_equal BigDecimal("8"), @product.reload.in_stock
  end

  test "insufficient stock rolls back document and every stock change" do
    assert_no_difference "Invoice.count" do
      assert_raises(DocumentWorkflow::InvalidTransition) do
        DocumentWorkflow.save!(Invoice.new(store: @store, user: @owner), invoice_attributes(quantity: 11), finalize: true)
      end
    end
    assert_equal BigDecimal("10"), @product.reload.in_stock
  end

  test "cross-store products and partners are rejected" do
    other = Store.create!(user: users(:admin), name: "Khác")
    customer = other.customers.create!(user: users(:admin), name: "Khách khác")
    invoice = Invoice.new(store: other, user: users(:admin))
    assert_raises(ActiveRecord::RecordInvalid) { DocumentWorkflow.save!(invoice, invoice_attributes) }
    invoice = Invoice.new(store: @store, user: @owner, customer: customer)
    assert_raises(ActiveRecord::RecordInvalid) { DocumentWorkflow.save!(invoice, invoice_attributes) }
  end

  test "negative quantities and excessive discounts fail" do
    [ -1, 0 ].each do |quantity|
      assert_raises(ActiveRecord::RecordInvalid) { DocumentWorkflow.save!(Invoice.new(store: @store, user: @owner), invoice_attributes(quantity:)) }
    end
    attributes = invoice_attributes.merge(discount_money: "999999")
    assert_raises(ActiveRecord::RecordInvalid) { DocumentWorkflow.save!(Invoice.new(store: @store, user: @owner), attributes) }
  end

  test "purchase adds inventory and cannot be canceled after inventory has been consumed" do
    purchase = Purchase.new(store: @store, user: @owner)
    attributes = { request_key: SecureRandom.uuid, product_purchases_attributes: [ { product_id: @product.id, quantity: 2, unit_price: 50, discount_money: 0 } ] }
    DocumentWorkflow.save!(purchase, attributes, finalize: true)
    assert_equal BigDecimal("12"), @product.reload.in_stock
    @product.update!(in_stock: 1)
    assert_raises(DocumentWorkflow::InvalidTransition) { DocumentWorkflow.transition!(purchase, "cancel") }
    assert purchase.reload.purchased?
    assert_equal BigDecimal("1"), @product.reload.in_stock
  end

  test "approved orders never move stock and finalized invoices are immutable" do
    supplier = @store.suppliers.create!(user: @owner, name: "Nhà cung cấp")
    order = PurchaseOrder.new(store: @store, user: @owner, supplier:, name: "Đặt hàng")
    DocumentWorkflow.save!(order, { product_purchase_orders_attributes: [ { product_id: @product.id, quantity: 2, unit_price: 50, discount_money: 0 } ] })
    DocumentWorkflow.transition!(order, "approve")
    assert_raises(DocumentWorkflow::InvalidTransition) { DocumentWorkflow.transition!(order, "complete") }
    assert order.reload.approved?
    assert_equal BigDecimal("10"), @product.reload.in_stock
    invoice = DocumentWorkflow.save!(Invoice.new(store: @store, user: @owner), invoice_attributes, finalize: true)
    assert_raises(DocumentWorkflow::InvalidTransition) { DocumentWorkflow.save!(invoice, { note: "Sửa sau chốt" }) }
  end

  private

  def invoice_attributes(quantity: 2, discount: 0)
    {
      request_key: SecureRandom.uuid, discount_money: 1, paid: 0, given_money: 0,
      product_invoices_attributes: [ { product_id: @product.id, quantity:, unit_price: "100.25", discount_money: discount } ]
    }
  end
end
