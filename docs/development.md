# Phát triển Park Việt

## Yêu cầu

Ruby 4.0.1 qua rbenv, PostgreSQL native và `pg_dump`, Node 22.12+,
Corepack và Yarn 1.22.22. Máy local không dùng Docker.

```sh
rbenv install 4.0.1
corepack enable
bundle install
yarn install --frozen-lockfile
```

PostgreSQL mặc định dùng Unix socket và user hiện tại. Tạo database riêng
trước khi chạy tác vụ backup/prepare:

```sh
createdb parkviet_development
createdb parkviet_test
bin/setup --skip-server
bin/dev
```

Ứng dụng ở `http://localhost:3000`; Vite ở port `3036`.
Không tạo server thứ hai nếu các port này đã được dùng.
Đăng ký qua `/users/sign_up`, sau đó tạo cửa hàng.
Không seed tài khoản hoặc mật khẩu mặc định.

## Biến môi trường

Có thể đặt trong dotenv bị Git ignore hoặc môi trường của process.
Không commit file dotenv, key, token hay credential.

| Biến | Dùng cho |
|---|---|
| `POSTGRES_HOST`, `POSTGRES_PORT` | Kết nối PostgreSQL local nếu không dùng socket |
| `POSTGRES_USER`, `POSTGRES_PASSWORD` | Thông tin kết nối local nếu cần |
| `POSTGRES_DB_NAME` | Mặc định `parkviet_development` |
| `POSTGRES_DB_NAME_TEST` | Mặc định `parkviet_test`; phải khác dev |
| `PARKVIET_BACKUP_DIR` | Thư mục backup **ngoài repository** |
| `DATABASE_URL` | PostgreSQL primary ở production |
| `CACHE_DATABASE_URL`, `QUEUE_DATABASE_URL`, `CABLE_DATABASE_URL` | Database riêng cho Solid services |
| `SECRET_KEY_BASE` | Secret Rails production |
| `APP_HOST`, `ASSUME_SSL`, `FORCE_SSL` | Host và SSL ở production |
| `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASSWORD` | Email khôi phục mật khẩu |
| `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET` | Google OAuth tùy chọn |

Không gán `DATABASE_URL` production vào terminal chạy test.
Production cần database application và ba database Solid; các DB này phải
được cấp quyền và tạo trước, không tự động provisioning qua app boot.

## Backup và thay đổi schema

`bin/rails parkviet:prepare` backup tất cả database của `RAILS_ENV` bằng
`pg_dump -Fc` trước khi gọi `db:prepare` và seed cấu hình quyền hệ thống.
Ở development, tác vụ backup cả dev và test vì Rails có thể đồng bộ schema test.
Nếu backup thất bại, tác vụ dừng trước thay đổi schema/dữ liệu.
Mặc định backup ở `~/.local/share/parkviet/backups`.

```sh
bin/rails parkviet:prepare
RAILS_ENV=test bin/rails parkviet:prepare
```

Giữ dump ở nơi riêng tư. Kiểm tra nội dung archive bằng `pg_restore -l`;
khôi phục chỉ vào database đích đã xác minh, không ghi đè DB thật khi thử.
Không dùng `db:reset`/`db:drop` để sửa lỗi thiết lập.

## Kiểm thử

```sh
# Backup test DB trước vì fixtures/test thay đổi dữ liệu.
RAILS_ENV=test bin/rails parkviet:prepare
CI=true bin/rails test
CI=true RAILS_ENV=test bin/vite build --mode test
CI=true bin/rails test:system
yarn run check
yarn build
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
bin/rails zeitwerk:check
```

Dùng `yarn run check`, **không** `yarn check`: Yarn 1 có lệnh `check` built-in
không thực hiện script TypeScript của project.
System tests dùng Chrome headless và database test; screenshot nằm ở
`tmp/screenshots/`. Không tạo demo data trong database development để test.

## Kiến trúc và quy tắc nghiệp vụ

UI Inertia tại `app/javascript/pages/workspace/`; component mới dùng kebab-case.
Controller Ruby giữ snake_case theo Rails. `StoreController` lấy cửa hàng từ
ownership/membership và session; không nhận tenant từ request body.

`StoreRole`/`Member` là quyền cửa hàng. `Role`/`Permission`/`Ability` của
starter là quyền quản trị hệ thống, không cấp qua màn hình nhân viên.

`DocumentWorkflow` chịu trách nhiệm chốt/hủy chứng từ trong transaction và
khóa cửa hàng/sản phẩm. Tiền được tính lại tại server, không tin các tổng tiền
client gửi. Chứng từ đã chốt chỉ hủy, không sửa các dòng đã hạch toán tồn kho.
Request key bảo vệ việc gửi lại một thanh toán. Hủy phiếu nhập bị từ chối nếu
làm tồn kho âm sau khi hàng đã được tiêu thụ.

`PaymentWorkflow` ghi lịch sử thu/chi và tăng số tiền đã trả trong transaction,
chặn thu vượt công nợ và chống request lặp. Tổng tiền hàng và tiền thừa lúc
bán giữ nguyên sau thu nợ. Đơn đặt nhập tự hoàn thành khi nhận đủ; hủy phiếu
nhập sẽ cập nhật số lượng còn thiếu và mở lại đơn.
