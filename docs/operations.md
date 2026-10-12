# Vận hành và deploy riêng

## Trạng thái

Chưa kết nối server, chưa build container, chưa deploy và chưa sửa DB server.
Database local mới không chứa dữ liệu nghiệp vụ legacy.
Kamal 2.11 đã cài cùng bundle. Không có Docker CLI/engine ở máy local.

Cấu hình deploy riêng nằm ngoài repository tại `~/.config/parkviet/`:

- `Dockerfile`, `dockerignore`: bản build Ruby 4.0.1, Node 22/Yarn.
- `deploy.yml`, `secrets`: cấu hình Kamal lấy giá trị từ ENV.
- `deploy-release.sh`: chuyển release đã commit qua SSH.
- `remote-deploy.sh`: chạy backup, migration và Kamal trên server.

`deploy.env` **chưa tạo được** vì privacy hook vẫn chặn. Operator phải tạo
file này quyền `600` trước khi dùng script; không gửi nội dung vào chat.
Các script chỉ được kiểm tra syntax local, chưa chứng minh deploy thành công.

## Không chạy Docker ở local

Kamal remote builder vẫn cần Docker CLI/buildx tại máy điều khiển. Vì vậy
phương án này chạy toàn bộ Kamal và Docker build trên server, máy local chỉ
SSH và đóng gói source. Chưa cài hay chạy Docker local.

Server cần chuẩn bị: Docker/buildx hoạt động, Ruby 4.0.1/Bundler,
`pg_dump` tương thích phiên bản PostgreSQL server, SSH đến chính destination,
registry, quyền database và kết nối mạng container đến PostgreSQL.
Các prerequisite này chưa được xác minh.

## Giá trị operator cần cấu hình

Tên biến trong file riêng, không chứa giá trị bí mật trong docs:

- `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_ARCH`, `DEPLOY_SERVICE`.
- `KAMAL_IMAGE`, `KAMAL_REGISTRY_SERVER`, `KAMAL_REGISTRY_USERNAME`,
  `KAMAL_REGISTRY_PASSWORD`.
- `APP_HOST`, `PROXY_SSL`.
- `SECRET_KEY_BASE`, `DATABASE_URL`, `CACHE_DATABASE_URL`,
  `QUEUE_DATABASE_URL`, `CABLE_DATABASE_URL`.
- `SSH_PASSWORD` chỉ khi cần; SSH key/agent được ưu tiên.

Phải verify SSH host key. Không tắt `StrictHostKeyChecking`.
Không chạy `kamal config` trong log chia sẻ vì lệnh có thể in secrets.
Không lấy plaintext secret từ command line hoặc commit chúng vào Git.

## Gate trước deploy

1. Code application được review, kiểm thử và commit; release chọn exact SHA.
2. Backup primary và Solid databases thành công và kiểm tra khả năng restore
   vào DB tách biệt. Backup nằm ngoài Git.
3. Xác minh server, DB, registry, domain/SSL và network của container.
4. Chạy script deploy riêng; không dùng `kamal setup` để tự ý cài thêm DB.
5. Kiểm tra `/up`, đăng nhập, tạo/đọc chứng từ và revision sau deploy.

Không gọi deploy là thành công chỉ từ push image hoặc container boot.
Build Docker chưa được kiểm tra trên máy này do yêu cầu không chạy Docker.

## Rollback

Giữ SHA/image cũ trước release. Kamal rollback application về revision cũ
chỉ khi schema tương thích. Không tự restore database vào production;
restore là thao tác riêng cần xác minh backup/đích và chấp thuận mất dữ liệu
phát sinh sau backup. Nhánh `master` giữ source Rails 5, không thể chạy trực
 tiếp trên schema Rails 8/PostgreSQL mới.
