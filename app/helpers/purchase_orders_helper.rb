module PurchaseOrdersHelper
  def self.replace_token_for_print(source, purchase_order)
    source.gsub!("{Ma_Dat_Hang_Nhap}", purchase_order.code)
    source.gsub!("{Ngay_Thang_Nam}", purchase_order.created_at.strftime("%d-%m-%Y"))
    source.gsub!("{Nguoi_Tao}", purchase_order.user.fullname)
    source.gsub!("{Nha_Cung_Cap}", purchase_order.supplier.present? ? purchase_order.supplier.name : "")
    source.gsub!("{Dia_Chi_Nha_Cung_Cap}", purchase_order.supplier.present? ? purchase_order.supplier.address : "")
#    source.gsub!("{Ngay_Nhap_Du_Kien}", purchase_order.expected_date.present? ? purchase_order.expected_date : "")

    source.gsub!("{Tong_So_Luong_Hang}", purchase_order.code)
    source.gsub!("{Tong_Tien_Hang}", purchase_order.code)
    source.gsub!("{Giam_Gia_Dat_Hang_Nhap}", purchase_order.code)
    source.gsub!("{Tong_Cong}", purchase_order.code)

    # source.gsub!("{}", purchase_order.id)
  end
end
