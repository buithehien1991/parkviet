# Phần mềm bán hàng Việt Nam và roadmap tính năng Park Việt

Ngày khảo sát: 12 tháng 10 năm 2026.
Đối chiếu với bản Rails 8 / React trên nhánh `rewrite/rails8-react`, theo [bản viết lại](rewrite-overview.md).

Tài liệu này gom sản phẩm thương mại có website chính thức, phần giao nhau của tính năng họ đang bán, và thứ tự làm cho Park Việt. Đây không phải bản sao hướng dẫn sử dụng của từng hãng, và không phải tư vấn pháp lý về thuế hay hóa đơn.

## Cách đọc danh sách

Một sản phẩm được đưa vào danh sách chính khi có đủ bốn điều:

- Có website chính thức của hãng, không phải bài review của bên thứ ba.
- Bán quyền sử dụng (SaaS theo gói, hoặc giấy phép cài đặt). Không phải mã nguồn mở.
- Làm phần mềm bán hàng: tính tiền, đơn, kho hoặc hợp kênh. Không chỉ là sàn thương mại, vận chuyển hay hóa đơn điện tử đứng riêng.
- Đang chào bán cho cửa hàng tại Việt Nam.

Thị trường còn hàng trăm gói nhỏ, đại lý lắp POS và phần mềm viết theo đơn. Không có danh bạ công khai nào liệt kê hết. Những tên dưới đây là nhóm có website và tài liệu công khai đủ để đối chiếu tính năng trong đợt này.

Số liệu kiểu “300.000 cửa hàng” là lời hãng tự công bố, chưa được kiểm toán trong khảo sát này.

Những gì đã đọc trực tiếp:

- KiotViet: bảng giá ngành, bài hướng dẫn bán hàng, đặt hàng, nhập hàng, thêm hàng hóa, thiết lập giá, và trang tổng quan nhóm giải pháp FnB.
- Sapo: trang Omnichannel và bài trợ giúp kết nối sàn.
- iPOS: trang sản phẩm FABi.
- MISA eShop, POS365, SoBanHang, Tendoo, CukCuk POS, TPos, WiOn, Suno, Pancake POS, Maybanhang.net, VNPT Posio, SofiPOS, Mmenu: trang giới thiệu chính thức hoặc trang sản phẩm được công cụ tìm kiếm trả về.

Chưa đọc hết trung tâm trợ giúp của từng hãng. Bộ tính năng bên dưới là phần giao của những gì các hãng đang quảng bá và hướng dẫn, không phải checklist nội bộ của họ.

## Tên dễ nhầm

- **Base.vn** ([base.vn](https://base.vn/)) là nền tảng vận hành doanh nghiệp: việc, nhân sự, chi phí, CRM, pipeline báo giá và hợp đồng. Không phải máy tính tiền bán lẻ.
- **TEDU / TEDUCO** ([tedu.com.vn](https://tedu.com.vn/), [teduco.vn](https://teduco.vn/)) là công ty phần mềm và nền tảng học trực tuyến. Phần “bán hàng” của họ là bán khóa học, mã giảm giá và thanh toán webhook, không phải POS cửa hàng. Tên gần với POS hơn trong đợt này là **TPos** ([tpos.vn](https://tpos.vn/)).
- **SaleX** ([salex.vn](https://salex.vn/)) xuất hiện như đơn vị tư vấn và lắp POS, không phải một sản phẩm bán hàng riêng.
- **POSBASIC** ([posbasic.net](https://posbasic.net/)) bán source code trả phí để cài hosting riêng. Không phải mã nguồn mở, nhưng cũng không phải SaaS đa cửa hàng kiểu KiotViet. Không lấy làm chuẩn cho Park Việt.

## Danh sách sản phẩm

### Bán lẻ và hợp kênh, dùng được cho cửa hàng như Park Việt

| Sản phẩm | Website | Hướng chính | Tài liệu công khai đã thấy |
| --- | --- | --- | --- |
| KiotViet (Citigo) | [kiotviet.vn](https://www.kiotviet.vn/) | POS đa ngành: bán lẻ, ăn uống, làm đẹp, lưu trú, nhà thuốc | [Hướng dẫn](https://www.kiotviet.vn/huong-dan-su-dung-kiotviet/), [bảng giá](https://www.kiotviet.vn/phi-dich-vu) |
| Sapo | [sapo.vn](https://www.sapo.vn/) | POS + website + sàn + mạng xã hội + hóa đơn, vận chuyển, kế toán | [Omnichannel](https://www.sapo.vn/tinh-nang-noi-bat-omnichannel.html), [help.sapo.vn](https://help.sapo.vn/) |
| MISA eShop | [misaeshop.vn](https://www.misaeshop.vn/) | Bán tại quầy và đa kênh, kéo sang hóa đơn, thuế, kế toán MISA | Trang sản phẩm và câu hỏi triển khai |
| POS365 | [pos365.vn](https://www.pos365.vn/) | POS cloud, nhấn mạnh bán khi mất mạng và hóa đơn từ máy tính tiền | Trang chủ sản phẩm |
| SoBanHang | [sobanhang.com](https://sobanhang.com/) | App bán hàng cho hộ kinh doanh: POS, catalog, sàn, thu chi, nhắc nợ | [Quản lý toàn diện](https://sobanhang.com/quan-ly-kinh-doanh-toan-dien/) |
| Tendoo (Viettel) | [tendoo.vn](https://tendoo.vn/) | Bán hàng, kho, vận chuyển, hóa đơn, sổ sách, trợ lý AI | Trang chủ |
| Nhanh.vn | [nhanh.vn](https://nhanh.vn/) | Gom đơn sàn, tồn kho, vận chuyển, POS | Tài liệu vận hành đa kênh được các bài so sánh trích từ site hãng |
| Haravan | [haravan.com](https://www.haravan.com/) | Website thương hiệu, POS chuỗi, CRM và quảng cáo | Trang nền tảng thương mại |
| Pancake POS | [pos.pancake.vn](https://pos.pancake.vn/) | Chat đa kênh (Messenger, Zalo, WhatsApp), đơn, kho, vận chuyển, thanh toán | Trang sản phẩm POS |
| TPos | [tpos.vn](https://tpos.vn/) | POS tại shop, livestream, Facebook, sàn, website. Cùng công ty với WiOn | Trang POS |
| WiOn | [wionplatform.com](https://wionplatform.com/) | Bán lẻ, nhà hàng, website kéo-thả, sàn và mạng xã hội | Trang nền tảng |
| Suno | [suno.vn](https://suno.vn/) | POS đơn giản, offline, website, Facebook, Zalo, nhiều điểm bán | Trang chủ |
| Maybanhang.net | [maybanhang.net](https://maybanhang.net/) | POS Windows tại quầy, app di động, offline rồi đồng bộ | Trang phần mềm bán hàng |
| GoSELL (Mediastep) | [gosell.vn](https://www.gosell.vn/) | Quản lý bán online và offline | Trang thương hiệu |
| VNPT Posio | [vnpt.vn](https://vnpt.vn/doanh-nghiep/san-pham-dich-vu/dich-vu-quan-ly-ban-hang-va-thanh-toan-vnpt-posio/) | POS cloud cho hộ và SME: hàng, đơn, kho, thanh toán, báo cáo | Trang dịch vụ VNPT |
| SofiPOS | [sofipos.com.vn](https://sofipos.com.vn/) | POS kèm hóa đơn máy tính tiền, thuế hộ kinh doanh, và nhiều ngành dọc | Trang chủ và bài so sánh của chính hãng |

### Ăn uống, gọi món, bếp

| Sản phẩm | Website | Hướng chính |
| --- | --- | --- |
| iPOS / iPOS FABi | [ipos.vn](https://ipos.vn/) | Order bàn, bếp/bar, kho định lượng, ca, chuỗi, GrabFood, ShopeeFood |
| MISA CukCuk | [cukcuk.vn](https://www.cukcuk.vn/) | Order, tạm tính, khuyến mại theo giờ/khu vực, giao ca, hóa đơn |
| Mmenu | [mmenu.io](https://mmenu.io/) | Gọi món QR tại bàn, đa ngôn ngữ, kéo về POS và bếp |
| KiotViet FnB, Sapo FnB, PosApp | Cùng site ở bảng trên và [posapp.vn](https://posapp.vn/) | Biến thể ăn uống của các hãng POS |

iPOS tách thêm HRM, kho, CRM. CukCuk nằm trong hệ MISA nên kéo được sang kế toán và hóa đơn.

### Hệ sinh thái quanh POS, không thay thế máy tính tiền

Các hãng POS Việt Nam gần như đều nối ra nhóm này. Park Việt nên tích hợp sau, không tự xây lại.

- Hóa đơn điện tử và chữ ký số: MISA meInvoice, VNPT Invoice, Viettel S-Invoice, cùng hóa đơn gắn trong KiotViet, Sapo, MISA eShop, POS365, Tendoo, SofiPOS.
- Vận chuyển: GHTK, GHN, Viettel Post, J&T, AhaMove, GrabExpress, và cổng vận chuyển của KiotViet hoặc Sapo.
- Thanh toán: VietQR/Napas, VNPay, MoMo, ZaloPay, thẻ. Hiện Park Việt chỉ ghi nhận khoản đã thu bên ngoài.
- Chat và mạng xã hội: Pancake, Haravan, Sapo, KiotViet cho Facebook, Zalo, Instagram.
- Sàn: Shopee, TikTok Shop, Lazada, Tiki. Sendo xuất hiện trong tài liệu Sapo cũ hơn là trọng tâm 2026.
- Kế toán: MISA AMIS, Sapo Accounting, phần kế toán hộ kinh doanh gắn POS.

### Không đưa vào danh sách làm chuẩn

- Mã nguồn mở hoặc lõi mở: Odoo Community, ERPNext, WooCommerce, Akaunting.
- Sàn và siêu app: Shopee, TikTok Shop, Lazada, Tiki. Đó là kênh bán, không phải phần mềm quản lý cửa hàng.
- POS quốc tế có mặt ở chuỗi lớn (Oracle MICROS, LS Retail, Microsoft Dynamics) không phải sản phẩm hộ kinh doanh Việt Nam. Chỉ cân nhắc nếu sau này có khách chuỗi yêu cầu chuẩn đó.

## Việc các hãng đang bán, gom theo nghiệp vụ

Cột trạng thái là Park Việt hiện tại, không phải độ phổ biến trên thị trường.

### 1. Bán tại quầy

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Tìm hàng theo tên, mã, mã vạch | Tất cả POS | Có |
| Nhiều giỏ / nhiều hóa đơn đang mở | KiotViet, POS365, Maybanhang | Có |
| Số lượng lẻ | KiotViet, Sapo | Có |
| Ghi chú dòng và ghi chú hóa đơn | KiotViet | Có |
| Bán ghi nợ | KiotViet, Sapo, SoBanHang | Có |
| Bán nhanh (mỗi lần chọn tăng 1) và bán thường (có ảnh) | KiotViet | Chưa |
| Nhiều bảng giá trên một hóa đơn: chung, VIP, theo nhóm khách, theo thời gian | KiotViet | Chưa |
| Thanh toán tách nhiều phương thức trên một hóa đơn | KiotViet | Một phần: ghi nhận khoản, chưa tách phương thức trên quầy |
| Tiền thừa, gợi ý mệnh giá | CukCuk, KiotViet | Chưa |
| Kênh bán: tại quầy, Facebook, điện thoại, khác | KiotViet, Sapo | Chưa |
| Thu khác: phí giao, phí dịch vụ, VAT dạng tiền hoặc phần trăm | KiotViet | Chưa |
| Đổi ngày giờ chứng từ, có khóa không cho sửa | KiotViet | Chưa |
| Trả hàng bán, có hạn mức thời gian trả | KiotViet, Sapo | Chưa |
| Đặt hàng khách, giao một phần, kết thúc đơn | KiotViet | Chưa |
| Sao chép hóa đơn | KiotViet | Có ở chứng từ |
| Chặn sửa chứng từ đã chốt | KiotViet | Có |
| Giữ giỏ khi mất mạng, rồi đẩy lên khi có mạng | POS365, Suno, Maybanhang, PosApp | Chưa. Giỏ chỉ nằm trong tab |
| Cân điện tử đổ số lượng | KiotViet | Chưa |
| Quét giọng nói để lên đơn | MISA eShop đang quảng bá | Chưa, và chưa cần |

### 2. Hàng hóa và giá

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Nhóm hàng, loại, nhà sản xuất, ảnh | KiotViet, MISA eShop | Có |
| Mã vạch, mã tự sinh | KiotViet | Cần kiểm tra mức độ trên dữ liệu hiện tại; tìm theo mã đã có |
| Thuộc tính tạo biến thể: màu, size, hương | KiotViet, MISA eShop (thời trang) | Chưa |
| Nhiều đơn vị tính trên một hàng, quy đổi | KiotViet | Chưa |
| Combo, bán kèm | SoBanHang, KiotViet | Chưa |
| Hàng sản xuất từ nguyên liệu, trừ định mức khi bán | KiotViet, iPOS | Chưa |
| Giá vốn bình quân từ phiếu nhập và trả nhập | KiotViet | Chưa thành chính sách giá vốn |
| Nhiều bảng giá, nhập xuất Excel, so sánh với giá vốn | KiotViet | Chưa |
| Lô, hạn dùng, xuất gần hết hạn trước, cảnh báo cận date | KiotViet nhà thuốc, MISA eShop | Chưa |
| Serial / IMEI, bảo hành theo serial | KiotViet, MISA eShop nội thất | Chưa |
| In tem mã vạch, tem kệ | KiotViet, SoBanHang | Chưa |

### 3. Kho

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Tồn theo cửa hàng, trừ khi chốt bán, cộng khi hủy bán | Tất cả | Có, một mức cửa hàng |
| Tồn âm có kiểm soát, hoặc cấm bán khi hết | KiotViet cho bật từng loại chứng từ | Chưa thành tùy chọn |
| Nhập hàng, trả hàng nhập | KiotViet | Nhập có. Trả nhập chưa tách thành nghiệp vụ riêng |
| Đặt hàng nhập, duyệt, nhận từng phần, cấm nhận quá | KiotViet | Có |
| Chi phí cộng vào phiếu nhập: vận chuyển, thuế | KiotViet | Chưa |
| Chuyển hàng giữa kho hoặc chi nhánh | KiotViet, Sapo | Chưa. Danh mục chi nhánh có, tồn chưa theo chi nhánh |
| Nhiều kho trong một cửa hàng: kho bán, kho trữ | KiotViet gói trả thêm | Chưa |
| Kiểm kho, điều chỉnh tăng giảm | KiotViet | Chưa |
| Xuất hủy | KiotViet | Chưa |
| Thẻ kho | KiotViet | Chưa |

### 4. Đối tác

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Khách hàng, nhà cung cấp, lịch sử giao dịch | Tất cả | Có |
| Công nợ, thu chi bổ sung, lịch sử tiền | KiotViet, SoBanHang | Có |
| Nhóm khách, hạng | KiotViet | Chưa |
| Tích điểm, đổi điểm ra tiền, nâng hạng | KiotViet, Sapo, SoBanHang | Chưa |
| Nhắc nợ | SoBanHang, KiotViet | Chưa |
| Đối tác giao hàng và trạng thái giao | KiotViet, Sapo, Nhanh | Chưa |
| Một hồ sơ khách xuyên kênh | Sapo, Haravan | Chưa, vì chưa có kênh ngoài quầy |
| SMS, Zalo, email chăm sóc | KiotViet, MISA eShop, SoBanHang | Chưa |
| Khách và công nợ tách theo chi nhánh | KiotViet | Chưa |

### 5. Tiền và ca

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Ghi nhận tiền mặt, chuyển khoản, thẻ như khoản đã xác nhận | Park Việt hiện vậy | Có |
| Sổ quỹ tiền mặt và tiền gửi | KiotViet, SoBanHang | Một phần qua thu chi, chưa sổ quỹ theo tài khoản |
| Phiếu thu, phiếu chi không gắn hóa đơn | KiotViet | Một phần |
| Mở ca, đóng ca, kiểm tiền két, doanh thu theo nhân viên ca | iPOS, CukCuk, KiotViet | Chưa |
| Đối soát sao kê hoặc báo tiền về | SoBanHang đang quảng bá loa và đối soát | Chưa |
| Cổng thanh toán thật, QR động theo số tiền hóa đơn | KiotViet Napas, iPOS ví | Chưa |
| Khóa sổ theo ngày | KiotViet | Chưa |
| Hoàn tiền khi hủy hóa đơn | Các POS tách khỏi việc hoàn kho | Chưa tự hoàn. Đúng với giới hạn hiện tại |

### 6. Khuyến mại

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Giảm giá dòng và giảm giá hóa đơn | Hầu hết POS | Cần xác nhận trên màn POS hiện tại trước khi coi là xong |
| Mua X tặng Y, giảm theo hóa đơn, tặng hàng, tặng điểm | KiotViet, iPOS, CukCuk | Chưa |
| Voucher, coupon, phát hành và trừ khi thanh toán | KiotViet | Chưa |
| Giá theo khung giờ, khu vực, phí dịch vụ | CukCuk, iPOS | Chưa |
| Khuyến mại đồng bộ giữa quầy và sàn | Sapo | Chưa |

### 7. Người dùng và chuỗi

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Nhân viên, vai trò, quyền | Tất cả POS khá | Có |
| Quyền từng thao tác nhạy cảm: xóa món, giảm giá, sửa hóa đơn | iPOS, KiotViet | Có khung quyền. Chưa gắn hết thao tác quầy |
| Nhật ký ai sửa gì | iPOS, Sapo | Chưa thành nhật ký nghiệp vụ đầy đủ |
| Nhiều chi nhánh, báo cáo gộp và tách | KiotViet, iPOS, MISA eShop | Danh mục chi nhánh có. Vận hành kho và doanh thu theo chi nhánh chưa |
| Hoa hồng, chấm công, lương | KiotViet gói chuyên nghiệp, iPOS HRM | Chưa |
| API cho đối tác | KiotViet gói cao, Mmenu, SofiPOS | Chưa thành sản phẩm |

### 8. Báo cáo

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Doanh thu và công nợ tổng quan | Park Việt | Có mức tổng quan |
| Cuối ngày: số hóa đơn, tiền theo phương thức, trả hàng | KiotViet, iPOS | Chưa |
| Bán hàng theo hàng, nhóm, nhân viên, khách, kênh, chi nhánh | KiotViet, Sapo | Chưa đủ bộ |
| Lãi lỗ dùng giá vốn | KiotViet, SoBanHang, Tendoo | Chưa |
| Top hàng bán chạy | KiotViet | Chưa |
| Hàng tồn, hàng chậm | KiotViet, Sapo | Chưa |
| So sánh kênh | Sapo, Nhanh, Haravan | Chưa |

### 9. In và thiết bị

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| In qua trình duyệt, đầu cuối trang, khổ giấy | Park Việt | Có |
| Mẫu riêng: đặt hàng, hóa đơn, trả hàng, nhập, chuyển, giao hàng | KiotViet | Chưa đủ loại |
| Máy in nhiệt, két, máy quét, màn hình khách | Maybanhang, iPOS, CukCuk | Chưa |
| In bếp theo khu vực, màn hình KDS | iPOS, CukCuk | Ngoài phạm vi bán lẻ trước mắt |

### 10. Thuế và hóa đơn điện tử

Đây là điểm các hãng đẩy mạnh trong năm 2026: xuất hóa đơn từ máy tính tiền, nối chữ ký số, kéo số liệu sang sổ hộ kinh doanh hoặc phần mềm kế toán. Tên nghị định trên website hãng (ví dụ nội dung MISA eShop, SofiPOS, POS365) là thông điệp bán hàng của họ. Trước khi làm, phải đọc văn bản đang hiệu lực, không copy checklist marketing.

Park Việt chưa xuất hóa đơn điện tử, chưa kê khai, chưa kế toán.

Việc đáng làm là nối một nhà cung cấp hóa đơn, không tự đứng ra làm cơ quan thuế.

### 11. Ngoài cửa hàng

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Website bán hàng dùng chung hàng và tồn | Sapo, Suno, Haravan, KiotViet | Chưa |
| Gom đơn Shopee, TikTok Shop, Lazada, Tiki | Sapo, Nhanh, MISA eShop, KiotViet, SoBanHang | Chưa |
| Gom chat Facebook, Zalo, tạo đơn từ hội thoại hoặc livestream | Pancake, Sapo, TPos, MISA eShop | Chưa |
| Tạo vận đơn, theo dõi COD | Sapo, Nhanh, Pancake | Chưa |
| Food app: GrabFood, ShopeeFood | iPOS, KiotViet FnB | Chưa, và chỉ cần nếu có mô hình quán |
| AI viết mô tả, trả lời chat, đọc lãi lỗ | Sapo, MISA eShop, Tendoo, SoBanHang | Chưa. Làm sau khi số liệu bán và giá vốn đã đúng |

### 12. Ngành dọc, chưa phải lõi Park Việt

Chỉ làm khi có cửa hàng thật thuộc ngành đó.

- Ăn uống: khu vực, bàn, tách gộp bàn, món thêm, in bếp, định lượng nguyên liệu.
- Làm đẹp: lịch hẹn, liệu trình, thẻ trả trước.
- Nhà thuốc: hoạt chất, số đăng ký, lô date, đơn thuốc, kết nối dữ liệu dược.
- Lưu trú: phòng, lịch ở, gộp bill ăn uống vào phòng.
- Tính giờ: karaoke, bida. SofiPOS đang dùng làm điểm khác biệt.

## Roadmap

Nguyên tắc: làm nốt vòng bán lẻ một cửa hàng trước. Hóa đơn điện tử và sàn chỉ có ích khi tồn, giá vốn, trả hàng và sổ quỹ đã khớp. Không mở cùng lúc FnB, nhà thuốc và AI.

Mỗi mục xong khi có đường đi trên giao diện, số liệu đúng sau khi chốt, và một trường hợp hủy hoặc sửa bị chặn vẫn đúng tồn và tiền.

### Giai đoạn 0 — Đang có

- [x] Đăng nhập, cửa hàng, nhân viên, vai trò, danh mục chi nhánh
- [x] Hàng hóa, nhóm, loại, nhà sản xuất, ảnh
- [x] Khách hàng, nhà cung cấp, công nợ, lịch sử
- [x] POS nhiều giỏ, số lượng lẻ, tìm tên hoặc mã, ghi chú, bán nợ
- [x] Hóa đơn và phiếu nhập: lọc, sao chép, chốt, hủy hoàn kho
- [x] Đặt nhập: duyệt, nhận từng phần, cấm nhận quá
- [x] Tiền tính ở server, chống thanh toán lặp, chứng từ đã chốt không sửa trực tiếp
- [x] In trình duyệt có đầu trang, cuối trang, khổ giấy
- [x] Tổng quan doanh thu và công nợ

### Giai đoạn 1 — Quầy bán dùng được cả ngày

Mục tiêu: nhân viên không phải nhảy ra quản trị để xử lý một ca bán bình thường.

- [ ] Bán nhanh và bán thường
- [ ] Sắp xếp dòng trong giỏ
- [ ] Chọn chi nhánh bán khi tài khoản được phép
- [ ] Chọn người bán khác người đang đăng nhập, nếu quyền cho phép
- [ ] Bảng giá: ít nhất một bảng chung và một bảng theo nhóm khách
- [ ] Kênh bán gắn trên hóa đơn
- [ ] Thu khác theo số tiền hoặc phần trăm
- [ ] Tách thanh toán: tiền mặt, chuyển khoản, ghi nợ trên cùng hóa đơn
- [ ] Tiền khách đưa và tiền thừa
- [ ] Trả hàng từ một hóa đơn đã chốt, hoàn tồn, ghi nhận tiền trả
- [ ] Không cho trả quá số đã bán, trừ phần đã trả trước đó
- [ ] Menu quầy: hóa đơn trong ngày, báo cáo rút gọn cuối ca

### Giai đoạn 2 — Kho vận hành

- [ ] Tồn theo chi nhánh, không chỉ theo cửa hàng
- [ ] Cấu hình được: cấm bán khi hết hàng, hoặc cho tồn âm
- [ ] Trả hàng nhập
- [ ] Chi phí nhập phân bổ vào giá vốn
- [ ] Giá vốn bình quân sau nhập, trả nhập và trả bán
- [ ] Kiểm kho có phiếu, chênh lệch, người kiểm
- [ ] Chuyển kho hoặc chuyển chi nhánh, trạng thái đang đi và đã nhận
- [ ] Xuất hủy có lý do
- [ ] Thẻ kho của một hàng
- [ ] Thuộc tính biến thể và đơn vị tính quy đổi
- [ ] Combo bán ra trừ thành phần

### Giai đoạn 3 — Đơn trước và giao sau

- [ ] Đặt hàng khách, giữ hoặc không giữ tồn
- [ ] Xuất hóa đơn từ đơn đặt một phần
- [ ] Trạng thái giao: chưa giao, đang giao, đã giao, hủy
- [ ] Phí giao trong thu khác
- [ ] Đối tác giao nội bộ, chưa cần API hãng vận chuyển

### Giai đoạn 4 — Quỹ và ca

- [ ] Tài khoản quỹ: tiền mặt, ngân hàng
- [ ] Phiếu thu, phiếu chi độc lập
- [ ] Mở ca và đóng ca, tiền đầu ca, tiền đếm, chênh lệch
- [ ] Doanh thu trong ca theo phương thức
- [ ] Khóa sổ: chứng từ trước ngày khóa không sửa
- [ ] Nhật ký thao tác xóa, sửa, giảm giá, hủy

### Giai đoạn 5 — Giá, khuyến mại, khách quay lại

- [ ] Nhiều bảng giá theo thời gian và chi nhánh
- [ ] Chương trình: giảm hóa đơn, giảm nhóm hàng, mua X tặng Y
- [ ] Voucher: phát hành, điều kiện, dùng một lần, trừ vào hóa đơn
- [ ] Tích điểm theo doanh thu, trừ điểm khi trả hàng
- [ ] Đổi điểm lúc thanh toán
- [ ] Nhóm khách và hạn mức công nợ
- [ ] Nhắc nợ trên danh sách khách, chưa cần Zalo

### Giai đoạn 6 — Báo cáo chủ cửa hàng

- [ ] Hôm nay: số hóa đơn, doanh thu, trả hàng, công nợ mới
- [ ] Cuối ngày theo phương thức thanh toán
- [ ] Theo hàng, nhóm hàng, nhân viên, khách, chi nhánh, kênh
- [ ] Lãi gộp khi đã có giá vốn
- [ ] Tồn dưới mức tối thiểu
- [ ] Xuất được các báo cáo này

### Giai đoạn 7 — In và mã hàng

- [ ] Mẫu in cho hóa đơn, trả hàng, đặt hàng, nhập, chuyển
- [ ] In tem mã vạch từ danh sách hàng
- [ ] Giữ mẫu an toàn như hiện tại, không nhận HTML tùy ý của người dùng

### Giai đoạn 8 — Hóa đơn điện tử

Chỉ bắt đầu sau khi hóa đơn bán và trả hàng đã ổn định.

- [ ] Chọn một nhà cung cấp hóa đơn có API công khai
- [ ] Phát hành từ hóa đơn đã chốt, lưu mã tra cứu
- [ ] Hủy hoặc thay thế hóa đơn điện tử khi trả hàng, đúng quy trình nhà cung cấp
- [ ] Không tự viết tờ khai thuế trong giai đoạn này

### Giai đoạn 9 — Kênh ngoài cửa hàng

Làm từng kênh, tồn phải trừ một lần.

- [ ] Trạng thái đơn thống nhất: mới, chốt, đóng gói, giao, hoàn
- [ ] Một kênh đầu tiên, ưu tiên cái cửa hàng thật đang dùng
- [ ] Đồng bộ tồn sau khi đơn kênh đó chốt hoặc hủy
- [ ] Đối soát tiền thu hộ
- [ ] Website catalog chỉ khi quầy và kho đã xong

### Giai đoạn 10 — Khi có ngành riêng

- [ ] FnB: bàn, bếp, món thêm
- [ ] Serial, bảo hành, lô date
- [ ] Lịch hẹn dịch vụ
- [ ] Chấm công và lương
- [ ] AI trên số liệu đã có

## Thứ tự không nên đảo

1. Trả hàng và tồn theo chi nhánh trước sàn thương mại. Đơn sàn hoàn về sẽ làm lệch kho nếu trả hàng còn thủ công.
2. Giá vốn trước báo cáo lãi. Báo cáo không có giá vốn chỉ là doanh thu.
3. Ca và sổ quỹ trước cổng thanh toán. QR chỉ là một phương thức trong ca.
4. Hóa đơn điện tử sau khi đã chặn sửa chứng từ đã chốt. Park Việt đã có chặn này, nên đủ điều kiện kỹ thuật để nối ở giai đoạn 8, không cần làm sớm hơn báo cáo.
5. AI và chat sau cùng. Các hãng đang dùng chúng để bán gói, trong khi cửa hàng vẫn sống nhờ tồn và tiền khớp.

## Còn bỏ ngỏ

- Chưa lập được danh sách tuyệt đối mọi giấy phép POS tại Việt Nam. Gói địa phương không có trang tính năng công khai nằm ngoài đợt này.
- Giá trên website thay đổi theo gói và khuyến mại. Không chép bảng giá vào roadmap.
- Quy định hóa đơn và thuế hộ kinh doanh đang được các hãng diễn giải khác nhau. Cần một đầu mối kế toán xác nhận trước giai đoạn 8.
- Mức “giảm giá trên POS” của Park Việt cần mở màn bán và thử một hóa đơn rồi mới đánh dấu xong trong giai đoạn 1.
