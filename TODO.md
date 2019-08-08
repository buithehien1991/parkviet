# Chức năng cần bổ sung
## Trang bán hàng
### Chung
- Chế độ Offline
### Thanh trạng thái
- Chế độ sử dụng cân điện tử
- Chế độ nhập: Nhanh & thường
- Cho phép chọn chi nhánh
- Trả hàng
- Thiết lập in
- Menu
   Xem báo cáo cuối ngày
   Xử lý đặt hàng
   Chọn hóa đơn trả hàng
   Lập phiếu thu
   Phát hành voucher
   Import
   Tùy chọn hiển thị
   Quản lý
   Thoát
### Phần thanh toán
- Tìm và Chọn người thanh toán
- Sửa | chọn ngày giờ thanh toán
- Chọn bảng giá: Bảng giá chung | Giá vốn | Giá VIP km 5%...
- Tùy chọn Giao hàng: Có | Không
- Chọn kênh bán hàng: Trực tiếp | Facebook | Khác... thêm kênh bán hàng
- Hóa đơn | Đặt hàng | Sửa chữa
- Thu khác: Giao hàng, ...
### Phần danh sách sản phẩm
- Sắp xếp sản phẩm trong giỏ hàng
- Gộp hàng hóa liên quan ??
- Lọc theo nhóm 
- Lọc theo thuộc tính hàng hóa

# MVC
## Manage
### Product Groups
- Edit product group
- Thêm position để order theo position bởi người dùng
- Paginate: Should write to module and can be reused by other component.

### Producer
- Edit producer
- Paginate: Will be completed after Product

### Customer
- Show detail with more information of this customer: Invoice, ReturnOrder
- ~~Paginate: Will be completed after Product~~

### Group Customer
- Do not everything

### Search & Filter module
- ~~Should be modularization to can be reused by many component~~ 

### Import & Export Excel
- Cho phép import dữ liệu từ Kiot Việt, Suno

### Printer
- Support normal printer: 
- Support invoice printer:

### Product
- Upload images for product: Need switch to upload image before create product. Write script to clean file if user close the create product without save.

### Branch
- Remove this model and use Store model with parent_id

# Other
## Common
- Add checking permission for delete: Product Group | Producer. Prevent hacking by check permission. 
- Add activity tracking to system. Should be put to background and should do after complete create new producer and before do other things
- Pagination

### Administrator
- Sử dụng Logstash (logstash-logger) + Elasticsearch + Kibana => Quản lý log
- Elasticsearch + Kibana => Theo dõi thói quen tìm kiếm của người dùng
- Kết hợp sử dụng docker để việc deploy sản phẩm trở lên dễ dàng

#### Admin dashboard
- For manage user/product
- Maintenance mode: http://blog.mohamad.im/2015/08/30/adding-a-dynamic-maintenance-mode-to-your-rails-app.html https://gist.github.com/necojackarc/35bac9f8cdeed5cf828e22d318bdb5d3

### Background processing
#### What use background jobs
- Index elasticsearch
- Export PDF/Word/Excel file - Integrate with Action Cable to use

#### Direction
- Use ActiveJobs. Trước tiên sử dụng AJ trước. Vì đã có nhiều kinh nghiệm với Sidekiq rồi nên dùng native xem có tốt hơn, dễ sử dụng hơn không. Thậm chí kết hợp cả 2 tùy vào tính chất mỗi công việc. 
- Use Sidekiq (Tốt hơn AJ khi cần set priority, retry task. Tóm lại sẽ tốt hơn AJ khi cần customize nhiều.)

### Autocomplete
- Using JqueryUI with autocomplete can be customize
- Our application use turbolink => How to adapt with turbolink when calling autocomplete: https://gorails.com/episodes/global-autocomplete-search

### Email system
