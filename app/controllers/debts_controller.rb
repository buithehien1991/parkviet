class DebtsController < StoreController
  def index
    invoices = current_store.invoices.completed.where("final_price > paid")
    purchases = current_store.purchases.purchased.where("final_price > paid")
    invoice_access = allowed?("invoice_view")
    purchase_access = allowed?("purchase_view")
    return head :forbidden unless invoice_access || purchase_access

    render inertia: "workspace/debts", props: {
      receivable: invoice_access ? invoices.sum("final_price - paid") : nil,
      payable: purchase_access ? purchases.sum("final_price - paid") : nil,
      customers: invoice_access ? partner_balances(invoices, :customer) : [],
      suppliers: purchase_access ? partner_balances(purchases, :supplier) : []
    }
  end

  private

  def allowed?(permission)
    owner? || current_member&.store_role&.permissions&.include?(permission)
  end

  def partner_balances(documents, association)
    table = association == :customer ? :customers : :suppliers
    documents.left_joins(association).group("#{table}.id", "#{table}.name", "#{table}.phone")
      .order(Arel.sql("SUM(final_price - paid) DESC"))
      .pluck("#{table}.id", "#{table}.name", "#{table}.phone", Arel.sql("COUNT(*)"), Arel.sql("SUM(final_price - paid)"))
      .map { |id, name, phone, count, balance| { id:, name: name.presence || "Chưa xác định đối tác", phone:, count:, balance: } }
  end
end
