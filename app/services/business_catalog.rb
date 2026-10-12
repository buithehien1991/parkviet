class BusinessCatalog
  def self.text(key, label, type = "text", required: false)
    { key: key.to_s, label:, type:, required: }
  end

  def self.select(key, label, options)
    { key: key.to_s, label:, type: "select", options: options.map { |value, label| { value: value.to_s, label: } } }
  end

  STATUS = { active: "Đang hoạt động", inactive: "Ngừng hoạt động", archived: "Lưu trữ" }.freeze
  PARTNER_FIELDS = [ text(:name, "Tên", required: true), text(:code, "Mã"), text(:company_name, "Công ty"), text(:phone, "Điện thoại"), text(:email, "Email", "email"), text(:address, "Địa chỉ"), text(:tax, "Mã số thuế"), text(:birthday, "Ngày sinh", "date"), text(:group, "Nhóm"), text(:description, "Ghi chú", "textarea"), select(:status, "Trạng thái", STATUS) ].freeze

  RESOURCES = {
    "products" => { model: Product, title: "Sản phẩm", permission: "product", fields: [ text(:name, "Tên sản phẩm", required: true), text(:code, "Mã / mã vạch"), text(:basic_unit, "Đơn vị"), text(:sale_price, "Giá bán", "number"), text(:cost_price, "Giá vốn", "number"), text(:in_stock, "Tồn kho", "number"), text(:in_stock_min, "Tồn tối thiểu", "number"), text(:in_stock_max, "Tồn tối đa", "number"), text(:vat, "VAT (%)", "number"), text(:description, "Mô tả", "textarea"), text(:note, "Ghi chú", "textarea"), select(:status, "Trạng thái", STATUS) ] },
    "customers" => { model: Customer, title: "Khách hàng", permission: "customer", fields: PARTNER_FIELDS },
    "suppliers" => { model: Supplier, title: "Nhà cung cấp", permission: "supplier", fields: PARTNER_FIELDS },
    "producers" => { model: Producer, title: "Nhà sản xuất", permission: "product", fields: [ text(:name, "Tên", required: true) ] },
    "product_groups" => { model: ProductGroup, title: "Nhóm sản phẩm", permission: "product", fields: [ text(:name, "Tên", required: true) ] },
    "product_types" => { model: ProductType, title: "Loại sản phẩm", permission: "product", fields: [ text(:name, "Tên", required: true) ] },
    "branches" => { model: Branch, title: "Chi nhánh", permission: "system", fields: [ text(:name, "Tên", required: true), text(:phone, "Điện thoại"), text(:address, "Địa chỉ") ] },
    "reports" => { model: Report, title: "Ghi nhận / báo cáo", permission: "report", fields: [ text(:title, "Tiêu đề", required: true), text(:content, "Nội dung", "textarea"), select(:status, "Trạng thái", { open: "Mở", in_progress: "Đang xử lý", on_hold: "Tạm dừng", closed: "Đóng" }) ] },
    "print_templates" => { model: PrintTemplate, title: "Mẫu in", permission: "system", fields: [ text(:name, "Tên mẫu", required: true), select(:template_type, "Loại chứng từ", { invoice: "Hóa đơn", purchase: "Nhập hàng", purchase_order: "Đặt nhập hàng" }), select(:size, "Khổ giấy", { a4: "A4", a5: "A5", k80: "80 mm", k58: "58 mm" }), text(:header, "Đầu trang", "textarea"), text(:footer, "Cuối trang", "textarea") ] }
  }.freeze

  def self.fields(key, store, record)
    fields = RESOURCES.fetch(key).fetch(:fields).map(&:dup)
    associations = case key
    when "products" then { producer_id: [ :producers, "Nhà sản xuất" ], product_group_id: [ :product_groups, "Nhóm sản phẩm" ], product_type_id: [ :product_types, "Loại sản phẩm" ] }
    when "product_groups" then { parent_id: [ :product_groups, "Nhóm cha" ] }
    else {}
    end
    associations.each do |field, (association, label)|
      scope = store.public_send(association).order(:name)
      scope = scope.where.not(id: record.id) if field == :parent_id && record.persisted?
      fields << select(field, label, scope.pluck(:id, :name))
    end
    fields << text(:images, "Ảnh sản phẩm", "file") if key == "products"
    fields
  end
end
