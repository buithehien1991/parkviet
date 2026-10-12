require "test_helper"

class PaymentReceivingTest < ActiveSupport::TestCase
  setup do
    @user = users(:member)
    @store = Store.create!(name: "Cửa hàng", user: @user)
    @product = @store.products.create!(name: "Hàng hóa", user: @user, sale_price: 100, in_stock: 10)
  end

  test "payment records initial cash then settles debt exactly once without changing sale totals" do
    invoice = Invoice.new(store: @store, user: @user)
    DocumentWorkflow.save!(invoice, { paid: 20, given_money: 30,
      product_invoices_attributes: [ { product_id: @product.id, quantity: 1, unit_price: 100, discount_money: 0 } ] }, finalize: true)
    assert_equal 1, invoice.document_payments.count
    attributes = { request_key: SecureRandom.uuid, amount: 80, payment_method: "transfer", date: Date.current }
    PaymentWorkflow.record!(invoice, user: @user, attributes:)
    assert_equal BigDecimal("100"), invoice.reload.paid
    assert_equal BigDecimal("100"), invoice.final_price
    assert_equal BigDecimal("10"), invoice.returned_money
    PaymentWorkflow.record!(invoice, user: @user, attributes:)
    assert_equal 2, invoice.document_payments.count
    assert_raises(DocumentWorkflow::InvalidTransition) do
      PaymentWorkflow.record!(invoice, user: @user, attributes: attributes.merge(request_key: SecureRandom.uuid, amount: 1))
    end
    DocumentWorkflow.transition!(invoice, "cancel")
    assert invoice.reload.canceled?
    assert_equal BigDecimal("10"), @product.reload.in_stock
    assert_equal BigDecimal("10"), invoice.returned_money
  end

  test "partial receipts enforce remaining quantity and reopen order when receipt canceled" do
    supplier = @store.suppliers.create!(name: "Nhà cung cấp", user: @user)
    order = PurchaseOrder.new(store: @store, user: @user, supplier:, name: "Đơn nhập")
    DocumentWorkflow.save!(order, { product_purchase_orders_attributes: [ { product_id: @product.id, quantity: 5, unit_price: 50, discount_money: 0 } ] })
    DocumentWorkflow.transition!(order, "approve")
    first = receive(order, supplier, 2)
    assert_equal BigDecimal("3"), order.remaining_quantities.fetch(@product.id)
    assert order.reload.approved?
    assert_raises(DocumentWorkflow::InvalidTransition) { receive(order, supplier, 4) }
    second = receive(order, supplier, 3)
    assert order.reload.completed?
    assert_equal BigDecimal("15"), @product.reload.in_stock
    assert_raises(DocumentWorkflow::InvalidTransition) { DocumentWorkflow.transition!(order, "cancel") }
    DocumentWorkflow.transition!(second, "cancel")
    assert order.reload.approved?
    assert_equal BigDecimal("3"), order.remaining_quantities.fetch(@product.id)
    assert first.reload.purchased?
  end

  private

  def receive(order, supplier, quantity)
    purchase = Purchase.new(store: @store, user: @user, supplier:, purchase_order: order)
    DocumentWorkflow.save!(purchase, { product_purchases_attributes: [ { product_id: @product.id, quantity:, unit_price: 50, discount_money: 0 } ] }, finalize: true)
  end
end
