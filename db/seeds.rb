# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ruby encoding: utf-8
StoreType.create(name: "Thời trang")
StoreType.create(name: "Bar-Cà phê-Nhà hàng")
StoreType.create(name: "Mẹ và bé")
StoreType.create(name: "Điện thoại & Điện máy")
StoreType.create(name: "Mỹ phẩm")
StoreType.create(name: "Nội thất & Gia dụng")
StoreType.create(name: "Hoa & Quà tặng")
StoreType.create(name: "Xe máy & linh kiện")
StoreType.create(name: "Sách & Văn phòng phẩm")
StoreType.create(name: "Tạp hóa")
StoreType.create(name: "Siêu thị mini")
StoreType.create(name: "Nông sản & Thực phẩm")
StoreType.create(name: "Nhà thuốc")
StoreType.create(name: "Khách sạn-Nhà nghỉ")
StoreType.create(name: "Vật liệu xây dựng")
StoreType.create(name: "Ngành hàng khác")

StoreKind.create(name: "Cửa hàng bán lẻ")
StoreKind.create(name: "Đại lý")
StoreKind.create(name: "Siêu thị")