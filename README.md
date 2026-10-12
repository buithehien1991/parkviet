# Park Việt

Phần mềm quản lý bán hàng mã nguồn mở dành cho cửa hàng nhỏ.
Nhánh `rewrite/rails8-react` viết lại từ template
[rails-8-vibe-starter](https://github.com/buithehien1991/rails-8-vibe-starter).
Bản Rails 5 / Vue cũ vẫn được giữ trên `master`.

## Stack

Ruby **4.0.1**, Rails **8.1.4**, PostgreSQL, Inertia, React 19, TypeScript,
Vite và Tailwind 4. Package manager: **Yarn 1.22.22**; Node 22.12+.
Local dùng PostgreSQL native, không cần Docker.

## Chạy local

Sau khi cài Ruby, PostgreSQL và Node:

```sh
corepack enable
bundle install
yarn install --frozen-lockfile
createdb parkviet_development
createdb parkviet_test
bin/setup --skip-server
bin/dev
```

Không chạy lại `createdb` nếu DB đã tồn tại. `bin/setup` backup DB trước khi
prepare/migrate. Mở `http://localhost:3000`, đăng ký và tạo cửa hàng.
Không có tài khoản hoặc mật khẩu mặc định.

## Tài liệu

- [Tổng quan chức năng và giới hạn](docs/rewrite-overview.md).
- [Thiết lập, biến môi trường, kiểm thử và kiến trúc](docs/development.md).

Các tài liệu `CHANGELOG.md`, `TODO.md`, `TIPS.md`, `doc/Marketing.md` và
screenshots lịch sử mô tả bản legacy. Không dùng chúng làm hướng dẫn chạy
nhánh Rails 8 hoặc coi các ý tưởng chưa hoàn thành là tính năng hiện có.

Cấu hình deploy và bí mật không nằm trong repository. Chưa import dữ liệu
MySQL cũ và chưa triển khai lên server.
