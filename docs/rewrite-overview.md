# Park Việt — bản Rails 8 / React

Nhánh `rewrite/rails8-react` thay nền Rails 5 / Vue bằng template
[`rails-8-vibe-starter`](https://github.com/buithehien1991/rails-8-vibe-starter)
ở revision `e5fa81228dff1c16bb93cc75c5974c3c88bd522c`.
Code và lịch sử cũ vẫn nằm trên `master`.

## Stack và thiết lập

- Ruby **4.0.1**, Rails **8.1.4**.
- PostgreSQL native trên máy; không cần Docker, MySQL, Redis hay Elasticsearch.
- Inertia Rails, React 19, TypeScript, Vite, Tailwind 4.
- Devise cho đăng nhập; quyền theo cửa hàng tách khỏi quản trị hệ thống.
- Package manager: Yarn **1.22.22**; Node **22.12+**.

Chi tiết cài đặt, biến môi trường và lệnh kiểm thử:
[Hướng dẫn phát triển](development.md).

## Chức năng của bản viết lại

- Đăng ký, đăng nhập, khôi phục mật khẩu và tạo cửa hàng.
- Sản phẩm, ảnh sản phẩm, nhóm hàng, loại hàng và nhà sản xuất.
- Khách hàng và nhà cung cấp.
- POS: nhiều giỏ hàng, nhập số lượng lẻ, tìm tên/mã vạch, ghi chú và bán ghi nợ.
- Hóa đơn/phiếu nhập: lọc ngày, trạng thái, đối tác và công nợ; sao chép chứng từ.
- Đơn đặt nhập: phê duyệt, nhận hàng từng phần, theo dõi còn thiếu và chặn nhập quá số lượng.
- Công nợ theo đối tác; thu/chi bổ sung và lịch sử khoản tiền thực tế.
- Tính tiền ở server với decimal; chốt/hủy cập nhật tồn kho trong transaction.
- Mã chống gửi thanh toán lặp; chứng từ đã chốt không sửa trực tiếp.
- Nhân viên, thông tin đăng nhập, vai trò, quyền truy cập và danh mục chi nhánh.
- Thông tin cửa hàng và lịch sử giao dịch khách hàng/nhà cung cấp.
- Tổng quan doanh thu/công nợ; ghi nhận báo cáo.
- In chứng từ qua trình duyệt, đầu/cuối trang và khổ giấy cấu hình được.
- Quản trị người dùng hệ thống kế thừa template tại `/admin`.

## Giới hạn cần biết

- Dùng database mới; **không import dữ liệu MySQL cũ**.
- Giỏ hàng lưu trong phiên tab trình duyệt, không phải chế độ bán hàng offline
  hoặc bảo đảm khôi phục sau mất điện.
- Chuyển khoản/thẻ là ghi nhận khoản thanh toán đã xác nhận bên ngoài,
  chưa tích hợp cổng thanh toán.
- Tồn kho hiện ở cấp cửa hàng, chưa tách kho theo chi nhánh.
- Mẫu in là cấu hình nội dung an toàn, không chạy HTML tùy ý.
- Hủy chứng từ hoàn tồn kho; tiền đã thu/chi không tự chuyển trả, cần xử lý hoàn tiền thực tế riêng.
- Bộ địa danh tỉnh/huyện/xã legacy chưa chuyển; hiện nhập địa chỉ dạng văn bản.
- Những ý tưởng AI, đồng bộ sàn TMĐT, vận chuyển, kế toán và offline trong
  tài liệu lịch sử chưa phải tính năng đã triển khai.
- Deploy chưa thực hiện. Cấu hình và hướng dẫn vận hành riêng được giữ ngoài Git,
  không lưu host hoặc credential trong repository.

README cũ, `CHANGELOG.md`, `TODO.md`, `TIPS.md` và `doc/Marketing.md` trong
lịch sử Git mô tả bản legacy, không phải hướng dẫn chạy bản Rails 8.
