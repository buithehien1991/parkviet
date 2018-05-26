# Giới thiệu
Park Việt là phần mềm quản lý bán hàng, kinh doanh sử dụng tại các điểm cửa hàng nhỏ, các đơn vị kinh doanh hộ gia đình, siêu thị hoặc trung tâm thương mại.

Ưu điểm của Part Việt so với các phần mềm bán hàng truyền thống
- Phần mềm chạy trên nền web, lưu trữ đám mây, không cần phải cài đặt, chỉ cần khởi tạo và sử dụng
- Phần mềm được hỗ lưu trữ bản sao, cho phép khôi phục lại dữ liệu khi có lỗi xảy ra.
- Cho phép người dùng sử dụng trên các thiết bị máy tính bảng, điện thoại từ xa để quản lý tình hình kinh doanh một cách dễ dàng. 

Ưu điểm của Part Việt so với các phần mềm bán hàng nền web khác
- Sử dụng học máy AI, deep learning để phân tích dữ liệu người dùng, đưa ra thói quen gợi ý trong quá trình bán hàng hoặc tiếp thị lại.
- Cho phép khách hàng có thể đặt hàng trước qua mạng.  
- Giá rẻ chỉ bằng nửa so với phần mềm rẻ nhất đang được bày bán. **Miễn phí** với toàn bộ cửa hàng vật liệu xây dựng.  
- Được tư vấn và hỗ trợ tận nơi, bổ sung các chức năng cần thiết cho từng mục đích của mỗi cửa hàng. Phù hợp với cá nhân, hộ gia đình kinh doanh nhỏ lẻ.  

# Hướng dẫn sử dụng
## Cài đặt
### Bước 1: Cài đặt database
 - rails db:migrate
 - rails db:seed
### Bước 2: Import CSDL tỉnh/huyện/xã
 - CSDL tại db/diadanh_2018-05-05.sql
### Bước 3: Cài đặt Redis & Elastic search

### Bước 4
 
## Đăng nhập và sử dụng


## Tips
Xóa cổng đang chạy

`lsof -wni tcp:3000`

`kill -9 xxxx` 
 
## Install & Run on Windows
### Error 
While executing gem ... (Encoding::ConverterNotFoundError)
    code converter not found (UTF-16LE to Windows-1258)
- chcp 850
 