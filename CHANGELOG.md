#CHANGE LOG

## Ngày 29-05-2018
### Thêm
- Upload image for Product
- Begin do Show page: Title

## Ngày 27-05-2018
### Thêm
- Create/Edit/Update/Index/Delete for Product
- Paginate for Product

## Ngày 26-05-2018
### Thêm
- Add gem for Auto complete search
- Complete model supplier basically

## Ngày 25-05-2018
### Thêm
- Add gem for paginate page.
- Add gem for full text search

## Ngày 24-05-2018
### Thêm
- Completed add new customer with validate & create code, abbr_name
### Sửa
- Đổi tên cột type thành customer_type và supplier_type vì xung đột tên biến trong rails


## Ngày 21-05-2018
### Thêm
- Thêm paper-trail để theo dõi các hoạt động trong cửa hàng. Cho phép người dùng có thể khôi phục dữ liệu trong tương lai  nếu có nhầm lẫn. Mặc định mọi yêu cầu được tracking sẽ có ip và user_agent phục vụ cho việc kiểm tra và thống kê sau này. Chỉ add tracking khi xong cơ bản model tránh phát sinh dữ liệu rác.
- Thêm pundit for xác thực quyền hạn để thực hiện các hành động tiếp theo của người dùng: VD thu ngân thì không thể thêm được hàng hóa nhưng được truy cập vào mục hóa đơn. Them khảo thêm việc phân quyền của Redmine.
### Sửa
### Xóa

## Ngày 20-05-2018
### Thêm
- Update information after create/remove producer. Only have Edit function
- Update UI for create new product. 
### Sửa
- Lưu & Tiếp tục not working correctly

## Ngày 19-05-2018
### Thêm
- Add/List/Delete Product Group items
- Sử dụng Acts_As_Tree để biểu diễn cây cha-con
- Sau khi thêm product group thì update lại group select
- Thêm Nhà sản xuất (Cần cập nhật lại thông tin khi tạo hoặc xóa thành công)
### Sửa
- Chuyển font-size global to 0.9rem

-- Template --
## Ngày 19-05-2018
### Thêm
### Sửa
### Xóa