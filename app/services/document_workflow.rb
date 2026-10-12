class DocumentWorkflow
  class InvalidTransition < StandardError; end

  def self.save!(document, attributes, finalize: false)
    document.store.with_lock do
      if document.new_record? && attributes[:request_key].present?
        existing = document.class.find_by(store_id: document.store_id, request_key: attributes[:request_key])
        return existing if existing
      end
      document.reload if document.persisted?
      if document.persisted? && !document.created?
        raise InvalidTransition, "Chỉ được sửa chứng từ nháp. Hãy hủy và tạo lại chứng từ đã chốt."
      end
      document.assign_attributes(attributes)
      document.save!
      finalize_locked!(document) if finalize
      document
    end
  end

  def self.transition!(document, action)
    document.store.with_lock do
      document.reload
      case action
      when "complete"
        return document if finalized?(document)
        raise InvalidTransition, "Chứng từ đã hủy" if document.canceled?
        if document.is_a?(PurchaseOrder)
          raise InvalidTransition, "Cần phê duyệt trước khi hoàn thành" unless document.approved?
          raise InvalidTransition, "Đơn chưa nhận đủ hàng. Hãy tạo phiếu nhập cho số lượng còn lại." unless document.remaining_quantities.values.all?(&:zero?)
          document.update!(status: :completed)
        else
          finalize_locked!(document)
        end
      when "approve"
        unless document.is_a?(PurchaseOrder) && document.created? && document.supplier.present?
          raise InvalidTransition, "Đơn cần ở trạng thái nháp và có nhà cung cấp"
        end
        document.update!(status: :approved)
      when "cancel"
        return document if document.canceled?
        if document.is_a?(PurchaseOrder) && document.purchases.purchased.exists?
          raise InvalidTransition, "Đơn đã có phiếu nhập. Hãy hủy các phiếu nhập trước."
        end
        stock_was_posted = finalized?(document) && !document.is_a?(PurchaseOrder)
        adjust_stock!(document, reverse: true) if stock_was_posted
        document.update!(status: :canceled)
        refresh_order!(document) if stock_was_posted && document.is_a?(Purchase)
      else
        raise InvalidTransition, "Trạng thái không hợp lệ"
      end
      document
    end
  end

  def self.finalized?(document)
    document.is_a?(Purchase) ? document.purchased? : document.completed?
  end

  def self.finalize_locked!(document)
    raise InvalidTransition, "Chỉ được chốt chứng từ nháp" unless document.created?
    validate_receipt!(document) if document.is_a?(Purchase) && document.purchase_order
    adjust_stock!(document)
    document.update!(status: document.is_a?(Invoice) ? :completed : :purchased)
    if document.paid.positive?
      document.document_payments.create!(store: document.store, user: document.user, amount: document.paid,
        request_key: "#{document.class.name}-#{document.id}-initial", date: document.date,
        payment_method: document.payment_method, note: "Thanh toán khi chốt chứng từ")
    end
    refresh_order!(document) if document.is_a?(Purchase)
  end

  def self.validate_receipt!(document)
    order = document.purchase_order.reload
    unless order.store_id == document.store_id && order.approved?
      raise InvalidTransition, "Đơn đặt nhập phải được phê duyệt và còn hàng chưa nhận."
    end
    raise InvalidTransition, "Nhà cung cấp không khớp đơn đặt nhập." unless order.supplier_id == document.supplier_id
    remaining = order.remaining_quantities
    document.lines.group_by(&:product_id).each do |product_id, items|
      if items.sum(&:quantity) > remaining.fetch(product_id, 0)
        raise InvalidTransition, "Số lượng nhập vượt quá số lượng còn lại trong đơn đặt nhập."
      end
    end
  end

  def self.refresh_order!(document)
    return unless (order = document.purchase_order)
    order.reload
    return if order.canceled?
    order.update!(status: order.remaining_quantities.values.all?(&:zero?) ? :completed : :approved)
  end

  def self.adjust_stock!(document, reverse: false)
    grouped = document.lines.group_by(&:product_id)
    products = document.store.products.where(id: grouped.keys).order(:id).lock.to_a
    raise InvalidTransition, "Sản phẩm không thuộc cửa hàng" unless products.size == grouped.size
    products.each do |product|
      quantity = grouped.fetch(product.id).sum(&:quantity)
      change = document.is_a?(Invoice) ? -quantity : quantity
      change = -change if reverse
      if !reverse && document.is_a?(Invoice) && !product.active?
        raise InvalidTransition, "#{product.name} đã ngừng kinh doanh"
      end
      new_stock = product.in_stock + change
      raise InvalidTransition, "#{product.name}: tồn kho không đủ" if new_stock.negative?
      product.update!(in_stock: new_stock)
    end
  end
  private_class_method :finalize_locked!, :adjust_stock!, :validate_receipt!, :refresh_order!
end
