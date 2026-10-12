# Park Việt

**Quản lý bán hàng, hàng hóa và công nợ cho cửa hàng nhỏ.**

Park Việt là ứng dụng web giúp chủ cửa hàng và nhân viên quản lý hoạt động
bán hàng trong một nơi: từ sản phẩm, khách hàng và nhà cung cấp đến nhập hàng,
hóa đơn và thanh toán. Mã nguồn được công khai để cộng đồng cùng tìm hiểu,
đóng góp và cải tiến.

## Tính năng

- **Bán hàng tại quầy:** tìm sản phẩm theo tên hoặc mã vạch, nhiều giỏ hàng,
  số lượng lẻ, giảm giá, ghi chú, thanh toán một phần và bán ghi nợ.
- **Hàng hóa:** quản lý sản phẩm, ảnh, đơn vị tính, giá vốn, giá bán, nhóm hàng,
  nhà sản xuất và ngưỡng tồn kho.
- **Nhập hàng:** tạo phiếu nhập, đặt hàng nhà cung cấp, phê duyệt và nhận hàng
  từng phần; theo dõi số lượng còn thiếu.
- **Hóa đơn và chứng từ:** tìm kiếm, lọc, sao chép, in, lưu nháp, chốt và hủy.
- **Đối tác và công nợ:** quản lý khách hàng, nhà cung cấp, lịch sử giao dịch,
  khoản phải thu/phải trả và lịch sử thu–chi.
- **Nhân viên:** quản lý tài khoản, vai trò và quyền truy cập theo cửa hàng.
- **Tổng quan:** doanh thu trong ngày, hóa đơn, sản phẩm sắp hết và công nợ.
- **Thiết lập:** thông tin cửa hàng, danh mục chi nhánh và mẫu in chứng từ.

### Phạm vi sử dụng

- Tồn kho được quản lý ở cấp cửa hàng, chưa tách riêng theo chi nhánh.
- Thanh toán tiền mặt, chuyển khoản và thẻ là ghi nhận khoản tiền đã xác nhận;
  ứng dụng chưa tích hợp cổng thanh toán.
- Giỏ hàng được lưu trong phiên tab trình duyệt; thanh toán cần kết nối đến
  server, không hỗ trợ bán hàng offline.
- Hủy chứng từ cập nhật lại tồn kho nhưng không tự hoàn tiền cho đối tác.

## Công nghệ

| Thành phần | Công nghệ |
| --- | --- |
| Backend | Ruby 4.0.1, Rails 8.1 |
| Database | PostgreSQL |
| Frontend | Inertia, React 19, TypeScript |
| Build và giao diện | Vite, Tailwind CSS 4 |
| Xác thực | Devise |
| Package manager | Yarn 1.22.22 |

Phiên bản dependency cụ thể được quản lý trong [Gemfile.lock](Gemfile.lock)
và [yarn.lock](yarn.lock).

## Bắt đầu

### Yêu cầu

- Ruby **4.0.1** và Bundler.
- Node.js **22.12 trở lên**, Corepack và Yarn **1.22.22**.
- PostgreSQL đang chạy; các lệnh `createdb` và `pg_dump` có trong `PATH`.
- Git.

### Cài đặt

```sh
git clone https://github.com/buithehien1991/parkviet.git
cd parkviet

corepack enable
createdb parkviet_development
createdb parkviet_test
bin/setup --skip-server
```

Hai database phải khác nhau. Nếu database đã tồn tại, bỏ qua lệnh `createdb`
tương ứng; không xóa database để chạy lại thiết lập.

`bin/setup` cài dependency và sao lưu database trước khi chuẩn bị schema.
PostgreSQL mặc định kết nối qua Unix socket với tài khoản hệ điều hành hiện tại.
Nếu bạn dùng host hoặc tài khoản PostgreSQL khác, cấu hình các biến môi trường
ở phần dưới trước khi chạy thiết lập.

### Chạy ứng dụng

```sh
bin/dev
```

Mở **http://localhost:3000**. Lệnh này chạy Rails và Vite cùng nhau.
Nếu đã có server đang chạy, không khởi động thêm một bản trên cùng port.

Bạn cũng có thể chạy riêng trong hai terminal:

```sh
# Terminal 1
bin/rails server

# Terminal 2
bin/vite dev
```

### Sử dụng lần đầu

1. Đăng ký tài khoản và tạo cửa hàng. Không có tài khoản hoặc mật khẩu mặc định.
2. Điền thông tin cửa hàng và thiết lập mẫu in nếu cần.
3. Thêm sản phẩm, khách hàng và nhà cung cấp.
4. Nhập hàng hoặc thiết lập tồn kho ban đầu, sau đó mở **Bán hàng**.
5. Xem hóa đơn và ghi nhận các khoản thu–chi bổ sung trong **Công nợ**.
6. Tạo vai trò và thêm nhân viên khi cần phân quyền.

## Cấu hình

Ứng dụng đọc cấu hình từ biến môi trường. Khi phát triển, có thể dùng file
`.env` tại thư mục gốc; không đưa file này hoặc giá trị bí mật vào Git.

| Biến | Ý nghĩa / mặc định |
| --- | --- |
| `POSTGRES_HOST` | Host PostgreSQL; để trống để dùng Unix socket |
| `POSTGRES_PORT` | Port PostgreSQL; mặc định `5432` |
| `POSTGRES_USER`, `POSTGRES_PASSWORD` | Tài khoản PostgreSQL nếu cần |
| `POSTGRES_DB_NAME` | Database development; mặc định `parkviet_development` |
| `POSTGRES_DB_NAME_TEST` | Database test; mặc định `parkviet_test` |
| `PARKVIET_BACKUP_DIR` | Thư mục backup ngoài repository; mặc định `~/.local/share/parkviet/backups` |

Xem [hướng dẫn phát triển](docs/development.md) để biết cấu hình email,
biến môi trường production, backup và các lệnh kiểm tra.

## Phát triển

```sh
# Kiểm tra kiểu dữ liệu frontend
yarn run check

# Build frontend
yarn build

# Kiểm tra định dạng Ruby
bin/rubocop
```

Khi chạy test có thay đổi dữ liệu, sao lưu database test trước và chọn file
liên quan đến phần đang sửa:

```sh
RAILS_ENV=test bin/rails parkviet:prepare
bin/rails test test/models/payment_receiving_test.rb
```

Hướng dẫn chi tiết: [docs/development.md](docs/development.md).

## Đóng góp

Mọi đóng góp về code, giao diện, tài liệu và báo lỗi đều được hoan nghênh.

1. Kiểm tra [Issues](https://github.com/buithehien1991/parkviet/issues) để tránh
   trùng lặp. Với thay đổi lớn, mở issue trao đổi trước khi triển khai.
2. Fork repository và tạo nhánh cho thay đổi của bạn.
3. Giữ thay đổi tập trung, bổ sung kiểm tra phù hợp và cập nhật tài liệu khi cần.
4. Mở pull request mô tả vấn đề, cách giải quyết và cách kiểm tra.

Khi báo lỗi, vui lòng cung cấp bước tái hiện, hành vi mong đợi, hành vi thực tế
và phiên bản môi trường. Không đính kèm mật khẩu, token, bản dump database
hoặc dữ liệu khách hàng.

## Giấy phép

Repository hiện chưa có tệp `LICENSE` xác định giấy phép sử dụng và phân phối.
Việc mã nguồn được công khai không đồng nghĩa với cấp quyền theo MIT, Apache
hoặc một giấy phép khác. Vui lòng trao đổi với chủ dự án trước khi sử dụng lại
hoặc phân phối mã nguồn.
