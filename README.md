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
 - lsof -wni tcp:3000
 - kill -9 xxxx 
 
## Install & Run on Windows
### Error 
While executing gem ... (Encoding::ConverterNotFoundError)
    code converter not found (UTF-16LE to Windows-1258)
- chcp 850
 