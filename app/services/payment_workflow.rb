class PaymentWorkflow
  def self.record!(document, user:, attributes:)
    document.store.with_lock do
      document.reload
      unless document.is_a?(Invoice) || document.is_a?(Purchase)
        raise DocumentWorkflow::InvalidTransition, "Đơn đặt nhập không ghi nhận thanh toán."
      end
      unless DocumentWorkflow.finalized?(document)
        raise DocumentWorkflow::InvalidTransition, "Chỉ thu / chi cho chứng từ đã chốt."
      end
      key = attributes[:request_key].to_s
      raise DocumentWorkflow::InvalidTransition, "Thiếu mã xác nhận thanh toán." if key.blank?
      existing = DocumentPayment.find_by(store: document.store, request_key: key)
      if existing
        raise DocumentWorkflow::InvalidTransition, "Mã thanh toán đã dùng cho chứng từ khác." unless existing.document == document
        return existing
      end
      payment = document.document_payments.build(attributes.merge(store: document.store, user:))
      payment.date ||= Date.current
      payment.validate!
      if payment.amount > document.final_price - document.paid
        raise DocumentWorkflow::InvalidTransition, "Số tiền vượt quá công nợ còn lại."
      end
      payment.save!
      document.update!(paid: document.paid + payment.amount)
      payment
    end
  end
end
