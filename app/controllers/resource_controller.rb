class ResourceController < StoreController
  before_action :authorize_resource!

  def index
    scope = resource_scope.order(id: :desc)
    query = params[:q].to_s.strip.first(100)
    if query.present?
      columns = (scope.column_names & %w[name code phone email title])
      clause = columns.map { |column| "#{column} ILIKE :query" }.join(" OR ")
      scope = scope.where(clause, query: "%#{ActiveRecord::Base.sanitize_sql_like(query)}%")
    end
    count = scope.count
    page = [ params[:page].to_i, 1 ].max
    records = scope.offset((page - 1) * 20).limit(20)
    render inertia: "workspace/resource-index", props: {
      resource: resource_key, title: resource_config[:title], records: records.map { |record| serialize(record) },
      fields: resource_config[:fields].reject { |field| field[:type] == "textarea" }.first(5),
      query:, pagination: { page:, pages: [ (count / 20.0).ceil, 1 ].max, count: },
      can_create: allowed?("new"), can_edit: allowed?("edit"), can_delete: allowed?("delete")
    }
  end

  def new
    render_form(resource_scope.new)
  end

  def edit
    render_form(resource_scope.find(params[:id]))
  end

  def show
    record = resource_scope.find(params[:id])
    render_form(record, readonly: true)
  end

  def create
    record = resource_scope.new(record_params)
    record.user = current_user if record.respond_to?(:user=)
    save_record(record)
  end

  def update
    record = resource_scope.find(params[:id])
    attributes = record_params
    new_images = attributes.delete(:images)
    record.assign_attributes(attributes)
    if record.is_a?(Product) && new_images.present?
      record.images = record.images.blobs.to_a + new_images
    end
    save_record(record)
  end

  def destroy
    record = resource_scope.find(params[:id])
    success = record.respond_to?(:archived!) ? record.update(status: :archived) : record.destroy
    redirect_to "/manage/#{resource_key}", success ? { notice: "Đã xóa / lưu trữ." } : { alert: record.errors.full_messages.to_sentence }
  end

  private

  def resource_key
    controller_name
  end

  def resource_config
    BusinessCatalog::RESOURCES.fetch(resource_key)
  end

  def resource_scope
    resource_config[:model].where(store: current_store)
  end

  def permission(action)
    resource_config[:permission] == "system" ? "system_setting" : "#{resource_config[:permission]}_#{action}"
  end

  def allowed?(action)
    owner? || current_member&.store_role&.permissions&.include?(permission(action)) || false
  end

  def authorize_resource!
    action = { "index" => "view", "show" => "view", "new" => "new", "create" => "new", "edit" => "edit", "update" => "edit", "destroy" => "delete" }.fetch(action_name)
    permit_store!(permission(action))
  end

  def record_params
    record = resource_scope.new
    fields = BusinessCatalog.fields(resource_key, current_store, record)
    keys = fields.reject { |field| field[:type] == "file" }.map { |field| field[:key] }
    permitted = params.require(:record).permit(*keys, images: [])
    permitted.each { |key, value| permitted[key] = nil if key.end_with?("_id") && value.blank? }
    permitted[:in_stock_max] = nil if permitted.key?(:in_stock_max) && permitted[:in_stock_max].blank?
    permitted
  end

  def save_record(record)
    if record.save
      redirect_to "/manage/#{resource_key}", notice: "Đã lưu #{resource_config[:title].downcase}."
    else
      render_form(record, status: :unprocessable_content)
    end
  rescue ArgumentError
    record.errors.add(:base, "Giá trị không hợp lệ")
    render_form(record, status: :unprocessable_content)
  end

  def serialize(record)
    keys = resource_config[:fields].map { |field| field[:key] } + %w[id producer_id product_group_id product_type_id parent_id]
    record.as_json(only: keys)
  end

  def partner_history(record)
    resource = case record
    when Customer then "invoices"
    when Supplier then "purchases"
    else return nil
    end
    permission = record.is_a?(Customer) ? "invoice_view" : "purchase_view"
    return nil unless owner? || current_member&.store_role&.permissions&.include?(permission)
    documents = record.public_send(resource).order(date: :desc, id: :desc)
    finalized = documents.where(status: record.is_a?(Customer) ? :completed : :purchased)
    {
      resource:, total: finalized.sum(:final_price), balance: finalized.sum("final_price - paid"),
      count: documents.count,
      documents: documents.limit(10).as_json(only: [ :id, :code, :date, :status, :final_price, :paid ])
    }
  end

  def render_form(record, readonly: false, status: :ok)
    render inertia: "workspace/resource-form", props: {
      resource: resource_key, title: resource_config[:title], record: serialize(record),
      fields: BusinessCatalog.fields(resource_key, current_store, record), readonly:,
      errors: record.errors.to_hash(true).transform_values(&:first),
      images: record.is_a?(Product) ? record.images.map { |image| url_for(image) } : [],
      can_edit: allowed?("edit"), partner_history: partner_history(record)
    }, status:
  end
end
