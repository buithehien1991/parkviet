class DocumentsController < StoreController
  before_action :authorize_document!

  def index
    filters = params.permit(:q, :status, :from, :to, :partner_id, :unpaid).to_h
    documents = scope.includes(partner_association).order(id: :desc)
    if filters["q"].present?
      query = "%#{ActiveRecord::Base.sanitize_sql_like(filters['q'].first(100))}%"
      documents = documents.where("code ILIKE :query OR name ILIKE :query", query:)
    end
    documents = documents.where(status: filters["status"]) if document_class.statuses.key?(filters["status"])
    documents = documents.where(partner_association => filters["partner_id"]) if filters["partner_id"].present?
    documents = documents.where("date >= ?", Date.iso8601(filters["from"])) if valid_date?(filters["from"])
    documents = documents.where("date <= ?", Date.iso8601(filters["to"])) if valid_date?(filters["to"])
    if filters["unpaid"] == "true" && document_class != PurchaseOrder
      documents = documents.where(status: document_class == Invoice ? :completed : :purchased).where("final_price > paid")
    end
    count = documents.count
    pages = [ (count / 20.0).ceil, 1 ].max
    page = params[:page].to_i.clamp(1, pages)
    render inertia: "workspace/document-index", props: {
      resource: controller_name, title:, filters:, statuses: document_class.statuses.keys,
      partners: partner_options, pagination: { page:, pages:, count: },
      documents: documents.offset((page - 1) * 20).limit(20).map { |document| serialize(document) },
      can_create: permitted?("new"), can_edit: permitted?("edit")
    }
  end

  def new
    document = scope.new(date: Date.current, request_key: SecureRandom.uuid)
    if params[:copy_from].present?
      permit_store!("#{permission_prefix}_view")
      return if performed?
      source = scope.find(params[:copy_from])
      document.assign_attributes(source.attributes.slice("name", "customer_id", "supplier_id", "discount_money", "note", "payment_method"))
      source.lines.each { |line| document.lines.build(line.attributes.slice("product_id", "quantity", "unit_price", "discount_money", "unit")) }
    elsif document.is_a?(Purchase) && params[:purchase_order_id].present?
      order = current_store.purchase_orders.find(params[:purchase_order_id])
      raise DocumentWorkflow::InvalidTransition, "Đơn cần được phê duyệt và còn hàng chưa nhận." unless order.approved?
      document.purchase_order = order
      document.supplier = order.supplier
      remaining = order.remaining_quantities
      order.lines.group_by(&:product_id).each do |product_id, lines|
        next unless remaining.fetch(product_id, 0).positive?
        document.lines.build(product_id:, quantity: remaining.fetch(product_id), unit_price: lines.first.unit_price, discount_money: 0, unit: lines.first.unit)
      end
    end
    render_form(document)
  end

  def show
    document = scope.find(params[:id])
    render inertia: "workspace/document-show", props: {
      document: serialize(document, with_lines: true), resource: controller_name, title:,
      store_details: current_store.as_json(only: [ :name, :phone, :address, :tax ]),
      print_template: current_store.print_templates.find_by(template_type: permission_prefix)&.as_json(only: [ :name, :size, :header, :footer ]),
      can_edit: permitted?("edit"), can_delete: permitted?("delete"), can_create: permitted?("new"),
      can_approve: permitted?("approve"), can_receive: permitted?("new_purchase") && store_permission?("purchase_new"),
      payment_request_key: SecureRandom.uuid, current_date: Date.current.iso8601,
      payments: document.respond_to?(:document_payments) ? document.document_payments.includes(:user).order(:created_at).map { |payment|
        payment.as_json(only: [ :id, :amount, :payment_method, :date, :note ]).merge(user_name: payment.user.name.presence || payment.user.email)
      } : [],
      receiving: document.is_a?(PurchaseOrder) ? receiving_details(document) : nil
    }
  end

  def edit
    document = scope.find(params[:id])
    raise DocumentWorkflow::InvalidTransition, "Chỉ được sửa chứng từ nháp" unless document.created?
    render_form(document)
  end

  def create
    persist(scope.new(user: current_user))
  end

  def update
    persist(scope.find(params[:id]))
  end

  def destroy
    DocumentWorkflow.transition!(scope.find(params[:id]), "cancel")
    redirect_to "/manage/#{controller_name}", notice: "Đã hủy chứng từ và hoàn lại tồn kho. Khoản tiền đã thu / chi cần hoàn trả thực tế riêng."
  end

  def status
    document = scope.find(params[:id])
    DocumentWorkflow.transition!(document, params[:transition])
    redirect_to document_url(document), notice: "Đã cập nhật chứng từ."
  end

  def payment
    document = scope.find(params[:id])
    PaymentWorkflow.record!(document, user: current_user, attributes: params.require(:payment).permit(:amount, :payment_method, :date, :note, :request_key).to_h.symbolize_keys)
    redirect_to document_url(document), notice: document.is_a?(Invoice) ? "Đã ghi nhận tiền thu." : "Đã ghi nhận tiền chi."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to document_url(document), inertia: { errors: error.record.errors.to_hash(true).transform_values(&:first) }
  end

  private

  def document_class
    { "invoices" => Invoice, "purchases" => Purchase, "purchase_orders" => PurchaseOrder }.fetch(controller_name)
  end

  def scope
    document_class.where(store: current_store)
  end

  def title
    { "invoices" => "Hóa đơn", "purchases" => "Nhập hàng", "purchase_orders" => "Đặt nhập hàng" }.fetch(controller_name)
  end

  def document_url(document)
    "/manage/#{controller_name}/#{document.id}"
  end

  def permission_prefix
    document_class.name.underscore
  end

  def store_permission?(name)
    owner? || current_member&.store_role&.permissions&.include?(name) || false
  end

  def permitted?(action)
    store_permission?("#{permission_prefix}_#{action}")
  end

  def authorize_document!
    action = case action_name
    when "status" then { "cancel" => "delete", "approve" => "approve" }.fetch(params[:transition], "edit")
    when "payment" then "edit"
    else { "index" => "view", "show" => "view", "new" => "new", "create" => "new", "edit" => "edit", "update" => "edit", "destroy" => "delete" }.fetch(action_name)
    end
    permit_store!("#{permission_prefix}_#{action}")
    if !performed? && document_class == Purchase && params[:purchase_order_id].present?
      permit_store!("purchase_order_new_purchase")
    end
  end

  def partner_association
    document_class == Invoice ? :customer : :supplier
  end

  def partner_options
    current_store.public_send(document_class == Invoice ? :customers : :suppliers).order(:name).as_json(only: [ :id, :name ])
  end

  def valid_date?(value)
    Date.iso8601(value.to_s)
    true
  rescue Date::Error
    false
  end

  def attributes_for(document)
    attributes = params.require(:document).permit(:name, :code, :date, :request_key, :customer_id, :supplier_id, :purchase_order_id, :discount_money, :paid, :given_money, :payment_method, :note,
      lines: [ :product_id, :quantity, :unit_price, :discount_money ])
    attributes.delete(document_class == Invoice ? :supplier_id : :customer_id)
    attributes.delete(:purchase_order_id) unless document_class == Purchase
    if document_class == Purchase && attributes[:purchase_order_id].present?
      permit_store!("purchase_order_new_purchase")
      return if performed?
      order = current_store.purchase_orders.find(attributes[:purchase_order_id])
      raise DocumentWorkflow::InvalidTransition, "Đơn cần được phê duyệt và còn hàng chưa nhận." unless order.approved?
    end
    attributes.each { |key, value| attributes[key] = nil if key.end_with?("_id") && value.blank? }
    lines = attributes.delete(:lines) || []
    line_attributes = lines.map do |line|
      product = current_store.products.find(line[:product_id])
      values = line.to_h.symbolize_keys
      values[:unit_price] = product.sale_price if document_class == Invoice && !owner? && !permitted?("edit")
      values[:unit_price] = product.sale_price if values[:unit_price].blank? && document_class == Invoice
      values[:unit_price] = product.cost_price if values[:unit_price].blank? && document_class != Invoice
      values
    end
    line_attributes += document.lines.map { |line| { id: line.id, _destroy: true } } if document.persisted?
    attributes["#{document.line_association}_attributes"] = line_attributes
    attributes
  end

  def persist(document)
    attributes = attributes_for(document)
    return if performed?
    saved = DocumentWorkflow.save!(document, attributes, finalize: params[:finalize].to_s == "true" && document_class != PurchaseOrder)
    redirect_to document_url(saved), notice: "Đã lưu chứng từ."
  rescue ActiveRecord::RecordInvalid => error
    if params[:source] == "sale" || request.referer&.end_with?("/sale")
      redirect_to sale_path, inertia: { errors: error.record.errors.to_hash(true).transform_values(&:first) }
    else
      render_form(error.record.is_a?(document_class) ? error.record : document, status: :unprocessable_content)
    end
  end

  def serialize(document, with_lines: false)
    value = document.as_json(only: [ :id, :name, :code, :date, :status, :request_key, :customer_id, :supplier_id, :purchase_order_id, :total_price, :discount_money, :final_price, :paid, :given_money, :returned_money, :payment_method, :note ])
    value[:partner_name] = document.public_send(partner_association)&.name
    if with_lines
      value[:lines] = document.lines.reject(&:marked_for_destruction?).map do |line|
        line.as_json(only: [ :product_id, :quantity, :unit_price, :discount_money, :final_price, :unit ]).merge(product_name: line.product&.name)
      end
    end
    value
  end

  def receiving_details(order)
    received = order.received_quantities
    remaining = order.remaining_quantities
    {
      lines: order.lines.group_by(&:product_id).map { |product_id, lines|
        { product_name: lines.first.product.name, ordered: lines.sum(&:quantity), received: received.fetch(product_id, 0), remaining: remaining.fetch(product_id, 0), unit: lines.first.unit }
      },
      purchases: order.purchases.order(id: :desc).as_json(only: [ :id, :code, :date, :status, :final_price ])
    }
  end

  def render_form(document, status: :ok)
    render inertia: "workspace/document-form", props: {
      resource: controller_name, title:, document: serialize(document, with_lines: true),
      products: current_store.products.where(status: [ :active, :inactive ]).order(:name).as_json(only: [ :id, :name, :code, :sale_price, :cost_price, :in_stock, :basic_unit ]),
      partners: partner_options,
      current_date: Date.current.iso8601,
      errors: document.errors.to_hash(true).transform_values(&:first)
    }, status:
  end
end
