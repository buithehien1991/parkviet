# Phần mềm bán hàng Việt Nam và roadmap tính năng Park Việt

Ngày khảo sát và bổ sung: 12 tháng 10 năm 2026, múi giờ Asia/Saigon.
Đối chiếu bản Rails 8 / React tại `main`, revision `c36d515`, và [tổng quan bản viết lại](rewrite-overview.md). Trạng thái bên dưới là ảnh chụp nghiên cứu, không thay thế source và kiểm thử.

**Kết quả:** danh bạ sản phẩm bán hàng thương mại phục vụ thị trường Việt Nam, nguồn hướng dẫn/marketing chính thức, danh mục hợp nhất tính năng và roadmap có checklist thực hiện. “Hợp nhất” nghĩa là lấy cả tính năng phổ biến lẫn tính năng riêng của từng mô hình, không chỉ phần giao nhau giữa các hãng.

Đây là roadmap đề xuất, chưa phải cam kết ngày giao hoặc quyết định triển khai mọi module ngay lập tức. Không sửa code ứng dụng trong đợt nghiên cứu này. Không sao chép nguyên văn kho bài viết, giao diện hoặc mã nguồn của hãng; không coi lời quảng cáo là bằng chứng kiểm thử hay tư vấn pháp lý.

## Điều hướng

- [Danh bạ và độ phủ nghiên cứu](#danh-ba).
- [Nhóm nghiệp vụ và khoảng trống Park Việt](#nghiep-vu).
- [Roadmap thực hiện](#roadmap).
- [Checklist bổ sung có mã công việc](#checklist-mo-rong).
- [Nguồn chính thức để đặc tả](#nguon).
- [Phần nghiên cứu chưa hoàn tất](#nghien-cuu-con-lai).
- [Nhật ký bằng chứng và giới hạn](../plans/reports/research-261012-2208-vn-pos-market.md).

## Cách đọc danh sách

Một sản phẩm được đưa vào danh sách chính khi có đủ bốn điều:

- Có website chính thức của hãng, không phải bài review của bên thứ ba.
- Chào bán quyền sử dụng hoặc dịch vụ phần mềm: SaaS, giấy phép cài đặt, hoặc hợp đồng triển khai. Bản miễn phí/dùng thử không đồng nghĩa với mã nguồn mở.
- Có nghiệp vụ bán hàng: POS, đơn, kho, đa kênh hoặc bán hàng doanh nghiệp. CRM, DMS và ERP được tách riêng, không giả định chúng thay thế quầy POS.
- Có trang chính thức hướng tới người dùng Việt Nam. Nhà cung cấp nước ngoài được ghi riêng; không giới hạn thị trường vào phần mềm do Việt Nam phát triển.

“Bản quyền” ở đây là sản phẩm/dịch vụ do hãng chào bán hợp pháp, không phải bản crack. Website sản phẩm và gói dịch vụ chứng minh mô hình thương mại; **không chứng minh toàn bộ thành phần bên trong không dùng mã nguồn mở**. Chưa kiểm toán EULA, quyền sở hữu mã nguồn hoặc điều kiện chuyển giao từng hợp đồng. Sản phẩm tự công bố lõi mở được loại khỏi danh sách chuẩn đóng.

Thị trường có thêm gói địa phương, đại lý lắp POS và phần mềm viết theo đơn. Chưa tìm được danh bạ công khai có thể chứng minh bao phủ toàn bộ. Những tên dưới đây là nhóm có website/tài liệu đã tìm thấy trong đợt này, kèm trạng thái xác minh.

Số liệu kiểu “300.000 cửa hàng” là lời hãng tự công bố, chưa được kiểm toán trong khảo sát này.

Độ phủ được phân biệt ngay trong danh bạ:

- **N**: đọc nội dung nghiệp vụ cụ thể của hãng; một số trang dài chỉ đọc phần liên quan, không tự nhận đã đọc toàn bài.
- **I**: đọc mục lục/chỉ mục hướng dẫn, chưa đọc hết các bài con.
- **M**: đọc trang sản phẩm, gói dịch vụ hoặc marketing; chưa kiểm chứng hành vi bằng tài khoản thực tế.
- **T**: mới có dấu vết tìm kiếm hoặc truy cập thất bại; không dùng làm bằng chứng tính năng đã xác minh.

Một hãng có thể có nhiều mức, ví dụ `N/I/M`. URL mục lục có hàng trăm bài không có nghĩa là hàng trăm bài đã được đọc. Chưa xem hết video, tải mọi PDF, khảo sát nội dung sau đăng nhập hoặc demo có hợp đồng. Không có mẫu số toàn thị trường nên không công bố tỷ lệ “đầy đủ 100%”. Hạn chế và lượt nghiên cứu tiếp theo nằm ở cuối tài liệu.

## Tên dễ nhầm

- **Base.vn / Base CRM** là nền tảng vận hành và bán hàng doanh nghiệp, không phải máy tính tiền bán lẻ. Vẫn đưa vào nhóm tham chiếu CRM/B2B vì báo giá, hợp đồng, pipeline, phân khúc và phê duyệt có ích cho roadmap.
- **TEDU / Teduco**: trang [tedu.com.vn](https://tedu.com.vn/) đọc được là đào tạo lập trình. Chưa có bằng chứng đây là sản phẩm POS thương mại; không suy ra các tính năng POS từ khóa học xây ứng dụng bán hàng. **Tendoo** ([tendoo.vn](https://tendoo.vn/)) của Viettel và **TPos** ([tpos.vn](https://tpos.vn/)) là hai tên bán hàng khác cần phân biệt.
- **SaleX / POSBASIC**: là đầu mối trong bản trước nhưng chưa đọc lại website/giấy phép. Chuyển vào danh sách chờ xác minh thay vì kết luận chắc chắn đại lý, bán source hay không mã nguồn mở.

<a id="danh-ba"></a>

## Danh sách sản phẩm

Website trong bảng là điểm vào chính thức đã khảo sát; cột tài liệu chỉ ghi đầu mối đã tìm thấy, không tự tạo URL trợ giúp từ tên hãng. Các mã `Sxx` trỏ tới bài cụ thể ở phần nguồn. Chưa có help công khai được ghi rõ, không phải kết luận hãng không có tài liệu.

### Bán lẻ và hợp kênh, dùng được cho cửa hàng như Park Việt

| Sản phẩm | Website / trang marketing | Hướng chính | Hướng dẫn và mức đọc |
| --- | --- | --- | --- |
| KiotViet (Citigo) | [kiotviet.vn](https://www.kiotviet.vn/) | Retail, FnB, Salon, Hotel; đa kênh, kho, giá, tuân thủ | [Hướng dẫn](https://www.kiotviet.vn/huong-dan-su-dung-kiotviet/); N/I/M; S01 |
| Sapo Omni / OmniAI / FnB | [sapo.vn](https://www.sapo.vn/) | Quầy, website, sàn, social, kho, vận chuyển, kế toán | [Help](https://help.sapo.vn/); N/I/M; S02–S05 |
| MISA eShop | [misaeshop.vn](https://www.misaeshop.vn/) | Retail, chuỗi, đa kênh, hóa đơn, thuế, kế toán | [Help đúng miền](https://helpeshop.misa.vn/); N/I/M; S06 |
| Nhanh.POS / Nhanh.vn | [nhanh.vn](https://nhanh.vn/) | POS, Ecom, Vpage, vận chuyển; đối soát và kho | [POS manual](https://pos.manual.nhanh.vn/), [API](https://developers.nhanh.group/); N/I/M; S10–S12, S21 |
| Haravan POS / Commerce | [Haravan POS](https://www.haravan.com/pages/phan-mem-quan-ly-cua-hang-hararetail) | Chuỗi, website, CRM Marketing, QR xác nhận thanh toán | [Help](https://help.haravan.com/); N/I/M; S07–S09, S29 |
| POS365 | [pos365.vn](https://www.pos365.vn/) | Cloud POS, offline, chuỗi, ca, hóa đơn | Trang sản phẩm đã đọc; help chi tiết chưa khảo sát; M; S18 |
| Sổ Bán Hàng | [Quản lý bán hàng](https://sobanhang.com/quan-ly-kinh-doanh-toan-dien/) | Mobile, catalog, sàn, kho, bàn, fanpage, Zalo OA | Trang nhóm tính năng; help từng nghiệp vụ chưa khảo sát; M |
| Tendoo (Viettel) | [tendoo.vn](https://tendoo.vn/) | Bán hàng, hóa đơn, thuế, tài chính, AI | Trang chủ và FAQ; chưa đọc đáp án toàn bộ FAQ; M |
| Pancake POS | [pos.pancake.vn](https://pos.pancake.vn/) | Đa kênh, chat, telesales, vận đơn, QR, sự kiện quảng cáo | [Docs](https://docs.pancake.biz/); I/M, một trang chỉ lấy được tóm tắt; S20 |
| TPos / TPage | [TPos POS](https://tpos.vn/phan-mem-quan-ly-ban-hang-pos) | Shop, fanpage, livestream, sàn | [Mục hướng dẫn](https://tpos.vn/blog/huong-dan); I/M; S22 |
| WiOn | [wionplatform.com](https://wionplatform.com/) | Tiếp nối TPos: bán online/offline, CRM, website | Trang hệ sinh thái; chưa có help độc lập được đọc; M |
| Suno | [suno.vn](https://suno.vn/) | POS đơn giản, offline, chuỗi, website/social | Trang chủ; chưa đọc help con; M |
| MAYBANHANG.NET | [maybanhang.net](https://maybanhang.net/) | POS đa thiết bị, back office, Ezmobile | Link sản phẩm trong trang chủ; M; offline cần đọc tài liệu riêng |
| VNPT POSIO | [VNPT dịch vụ](https://vnpt.vn/doanh-nghiep/san-pham-dich-vu/dich-vu-quan-ly-ban-hang-va-thanh-toan-vnpt-posio/), [posio.vn](https://www.posio.vn/) | SaaS cho hộ/SME, đặt cọc, voucher, kho, báo cáo | Trang VNPT và sản phẩm; chưa đọc manual; M |
| SOFIPOS | [sofipos.vn](https://sofipos.vn/) | Bán hàng đa ngành, quản trị và hệ sinh thái | Miền `.com.vn` cũ không truy cập được; miền `.vn` đọc được; M, chưa xác nhận quan hệ hai miền |
| EasyPOS (Softdreams) | [easypos.vn](https://easypos.vn/) | POS gắn EasyInvoice, hóa đơn máy tính tiền, thuế | [Support](https://support.easypos.vn/) hiện lấy được FAQ; M; S28 |
| UPOS | [upos.vn](https://upos.vn/) | Quầy, livestream, sàn, vận chuyển, ký nhận một phần | [Mobile help](https://mhelp.upos.vn/); N/I/M; S15, S23 |
| TrustSales | [trustsales.vn](https://trustsales.vn/) | Fanpage, giao việc, trạng thái đơn, kiểm soát sales | Trang chủ và mục tin của hãng; chưa đọc manual; M |
| Salekit | [salekit.com](https://salekit.com/) | POS, CRM, funnel, website, automation, vận chuyển | [Help sản phẩm](https://help.salekit.com/san-pham.html); N/M; S16 |
| Nobi.Pro (Nobita) | [nobi.pro](https://nobi.pro/) | Hội thoại, đơn và chăm sóc/marketing tự động | `nobita.pro` chuyển hướng về đây; trang module đã đọc; M |
| Omisell | [omisell.com](https://omisell.com/) | OMS đa kênh, fulfillment Boxme, lợi nhuận theo SKU | Trang sản phẩm; help/API chưa khảo sát; M, chưa kiểm chứng số liệu marketing |
| MobiFone 1POS | [Trang chính thức](https://solutions.mobifone.vn/vi/quan-ly-ban-hang-mobifone-1pos) | POS/chuỗi, phiên làm việc, tiền mặt, loyalty, hóa đơn | Trang module chính thức; chưa đọc manual; M; S30 |
| CitiPOS | [citipos.vn](https://citipos.vn/) | POS đa ngành, website, CitiPAY, chuỗi | Trang sản phẩm và gói dịch vụ; chưa đọc manual; M |
| TNCBASE POS | [tncbase.com/pos](https://tncbase.com/pos) | PWA offline-first, đa chi nhánh, kho, điểm | Trang sản phẩm/gói; M; app chủ cửa hàng được ghi **sắp ra mắt**, không coi đã có |

### Bản cài đặt, LAN/offline và giải pháp tùy chỉnh

| Sản phẩm | Website / nguồn chính thức | Hướng chính | Mức đọc và giới hạn |
| --- | --- | --- | --- |
| DanTriSoft | [Bảng bản quyền](https://dantrisoft.com.vn/bang-gia/) | Online/offline, giấy phép trọn đời, kho, định lượng, quỹ, VIP | M; đối chiếu quyền theo gói; S24 |
| MasterPro | [masterpro.com.vn](https://www.masterpro.com.vn/) | Bán lẻ/sỉ, mua, kho, quỹ, giao ca, ngân sách, chuỗi | M; đã đọc danh sách module, chưa đọc hết từng module |
| HTsoft BizMan / SalePro | [htsoft.vn](https://htsoft.vn/) | Bán hàng/chuỗi, kho, phân phối, bảo hành | M; [manual](https://htsoft.vn/phan-mem-quan-ly/index.htm) tìm thấy nhưng chưa trích xuất được |
| Winta Sales / POS | [Trang POS Winta](https://www.winta.com.vn/branch/165/phan-he-phan-mem-quan-ly-ban-le-phan-mem-pos-winta.html) | Đa đơn vị, cân, giá, kích thước, phân phối, ERP | M; nội dung có thông tin công nghệ cũ, không suy ra API hiện hành; S26 |
| EBIZ / EbizStore | [e-biz.com.vn](https://www.e-biz.com.vn/) | Offline/local, retail, loyalty, spa, bảo hành | M; trang EbizStore đã đọc, chưa có manual trọn bộ; S25 |
| NamVietSoft | [Điện máy](https://namvietsoft.vn/phan-mem-quan-ly-cua-hang-dien-may) | POS đa ngành, IMEI, kho, VIP; license cài đặt | M; trang có gói bản quyền, chưa đọc manual |
| RIC / mRIC / RICpc | [ric.vn](https://ric.vn/) | Online/offline, POS, kho, công nợ, ghi đơn thị trường | M; RICpc/combo/bảo hành là biến thể, không đếm như hãng độc lập |
| VQSOFT / VQSALE / VQCAFE | [vqsoft.net](https://vqsoft.net/) | Bán hàng Windows, bản miễn phí và thương mại | [Hướng dẫn](https://vqsoft.net/Huong-dan-su-dung/); I/M; nhiều bài cũ, chưa xác minh gói bán hiện tại |
| BLUESOFTS BS GOGO / BS Silver | [BS GOGO](https://bluesofts.net/giai-phap-phan-mem/phan-mem-quan-ly-ban-hang-bs-gogo.html), [BS Silver](https://bluesofts.net/giai-phap-phan-mem/bs-silver-phan-mem-quan-ly-kho.html) | Bán hàng/kho, báo giá, đa đơn vị, giá xuất kho, import số dư | M; đã đọc bài nâng cấp BS Silver, chưa xem video; S27 |
| AZPOS | [Giải pháp và gói](https://azpos.vn/giai-phap-phan-mem-quan-ly-ban-hang/) | Cloud/offline, FnB/retail, kho, định lượng, tính giờ | M; hãng cũng bán hãng khác, chỉ lấy trang phần mềm mang tên AZPOS |
| VietPOS | [vietpos.com](https://vietpos.com/) | POS đa ngành, ERP, ca, BOM, cảnh báo, AI | M; chưa xác nhận quan hệ với `vietpos.vn`, không gộp hai miền tự động |

### Ăn uống, gọi món, bếp

| Sản phẩm | Website | Hướng chính |
| --- | --- | --- |
| iPOS / iPOS FABi | [ipos.vn](https://ipos.vn/) | Order bàn, bếp/bar, kho định lượng, ca, chuỗi, GrabFood, ShopeeFood |
| MISA CukCuk | [cukcuk.vn](https://www.cukcuk.vn/) | Order, tạm tính, khuyến mại theo giờ/khu vực, giao ca, hóa đơn |
| Mmenu | [mmenu.io/vn/vi](https://mmenu.io/vn/vi) | QR order, EasyPos của Mmenu (khác EasyPOS Softdreams), bếp, kho công thức, loyalty, Zalo Mini App; M |
| PosApp | [posapp.vn](https://posapp.vn/) | Retail/FnB/dịch vụ, KDS, kiosk, thẻ trả trước, API, chuỗi; N/I/M |
| Relipos (Relisoft) | [relipos.com](https://relipos.com/) | FnB, bar, retail, hotel, chuỗi và API; M |
| NexPOS | [home.nexpos.io](https://home.nexpos.io/) | Quản trị điểm bán và hệ sinh thái nhượng quyền; M; chưa kiểm chứng offline/đa nền tảng trong bản hiện tại |
| KiotViet FnB / Sapo FnB | Cùng website hai hãng ở bảng trên | Biến thể ngành, không phải hai nhà cung cấp mới |

iPOS: đã đọc [FABi](https://ipos.vn/phan-mem-quan-ly-ban-hang-ipos-fabi/), [mục lục Web Order](https://huongdan.ipos.vn/docs/tai-lieu-van-hanh-ipos-web-order-fabi/) và bài vận hành Deli (`N/I/M`, S13/S42). CukCuk: đã đọc [mục lục nghiệp vụ](https://helpv2.cukcuk.vn/vi/ac/huong-dan-nghiep-vu-cho-nha-hang-vua-va-lon) (`I/M`, S14). PosApp: [bán lẻ](https://retail-docs.posapp.vn/) và [FnB](https://docs.posapp.vn/); đọc thêm bài quỹ tiền (`N/I/M`, S19). Những phân hệ HRM, Inventory, CRM hoặc Lomas không mặc nhiên nằm trong một gói POS.

### Nhà thuốc, làm đẹp và dịch vụ

| Sản phẩm | Website chính thức | Nghiệp vụ đáng đưa vào backlog | Mức đọc |
| --- | --- | --- | --- |
| Myspa | [myspa.vn](https://myspa.vn/) | Lịch hẹn, hồ sơ liệu trình, ảnh/chữ ký, công nợ, hoa hồng, app/Zalo | M; chưa đọc kho hướng dẫn |
| SalonHero | [salonhero.vn](https://salonhero.vn/) | Lịch hẹn, SMS/Zalo, thẻ dịch vụ, số buổi/số tiền, nhân viên | M; chưa đọc kho hướng dẫn |
| Medlink Pharmacy | [medlink.vn/pharmacy](https://medlink.vn/pharmacy/) | Nhà thuốc/chuỗi, dược quốc gia, loyalty, mobile | M; trang có gói miễn phí/trả phí; S31 |
| VNPT Pharmacy | [Bài chính thức VNPT](https://vnpt.vn/doanh-nghiep/tu-van/vnpt-pharmacy.html) | Lô, hạn dùng, đơn vị hộp/vỉ, chuỗi, hóa đơn | M; bài năm 2019, phải xác minh phiên bản hiện hành trước đặc tả |

Các nhánh KiotViet Salon/Hotel/nhà thuốc, EBIZ Spa/HMS/Warranty, POS365/PosApp theo ngành đã tính trong gia đình sản phẩm tương ứng.

### Bán hàng doanh nghiệp: CRM, DMS, ERP và vận hành

Nhóm này đáp ứng ví dụ **Base** của người dùng, nhưng không trộn thành đối thủ máy tính tiền. Website dịch vụ đã đọc; giấy phép/lõi triển khai và tài liệu chuyên sâu chưa kiểm toán.

| Sản phẩm / gia đình | Website chính thức | Phần liên quan đến bán hàng | Hướng dẫn / mức đọc |
| --- | --- | --- | --- |
| Base CRM / Base.vn | [base.vn/crm](https://base.vn/crm) | Account/contact, deal, pipeline, segmentation, báo giá/hợp đồng, phê duyệt | [CRM Sales help](https://help.base.vn/support/solutions/folders/63000239062); I/M; S17 |
| MISA AMIS CRM | [Bài tích hợp quy trình](https://amis.misa.vn/159787/amis-crm-ket-noi-voi-amis-quy-trinh-de-gui-yeu-cau-phe-duyet-mua-hang/) | Sales gắn yêu cầu mua hàng và duyệt | [Help CRM](https://helpcrm.misa.vn/kb/ket-noi-voi-amis-quy-trinh-quy-trinh-mua-hang/); N/M; S43 |
| Getfly CRM | [getfly.vn](https://getfly.vn/) | Hồ sơ khách, automation, KPI, API | M; help chi tiết chưa đọc |
| CloudGO | [cloudgo.vn](https://cloudgo.vn/) | CRM theo ngành, bảo hành, email, web, BI | M; trạng thái lõi/giấy phép chưa xác minh, không dùng làm chuẩn đóng đã xác nhận |
| NextX Sales / CRM / DMS | [nextx.vn](https://nextx.vn/) | POS/đơn/kho, CRM, chat/call, DMS, HRM | M; nhiều nội dung AI là lời quảng bá, chưa thử thao tác |
| FAST Business / DMS / CRM | [fast.com.vn](https://fast.com.vn/) | ERP, kênh phân phối, khách hàng, kế toán | M; chưa đọc manual từng phân hệ |
| BRAVO ERP | [bravo.com.vn](https://www.bravo.com.vn/) | Quy trình quản trị tích hợp, tài chính, vận hành doanh nghiệp | M; chưa đọc đặc tả phân hệ bán hàng |
| MekongSoft | [mekongsoft.com.vn](https://mekongsoft.com.vn/) | Bán sỉ/phân phối, PO, kho, công nợ, ERP/MES theo yêu cầu | M; giải pháp hợp đồng, không phải một gói POS thống nhất |
| Faceworks (TIT) | [faceworks.vn](https://faceworks.vn/) | Lead, sales, báo giá, hợp đồng, mua/kho, workflow | M; nền tảng tùy biến, chưa kiểm toán giấy phép |
| Viettel DMS | [dmsviettel.vn](https://dmsviettel.vn/) | Tuyến sales, sell-in/out, lot/date, trưng bày, KPI | M; không gộp với Tendoo |
| MobiWork DMS | [mobiwork.vn](https://mobiwork.vn/) | Pre-sales, van-sales, tuyến, nhà phân phối, trade marketing | M; **chỉ DMS**, loại gói ERPNext lõi mở khỏi chuẩn đóng |
| MobiFone Smart Sales | [Trang chính thức](https://solutions.mobifone.vn/vi/giai-phap-quan-ly-ban-hang-mobifone-smart-sales) | Sales, marketing, chăm sóc, theo dõi kinh doanh | M; khác sản phẩm 1POS |
| BMS | [bms.im/vi](https://bms.im/vi) | Báo giá, mua/bán, kho, CRM, ticket, tài chính | M; chỉ trang giới thiệu, pháp nhân/gói/giấy phép cần xác minh thêm |

### Sản phẩm quốc tế và khả năng cung cấp tại Việt Nam

| Sản phẩm | Website hãng | Bằng chứng thị trường / giới hạn |
| --- | --- | --- |
| LS Central (LS Retail) | [lsretail.com](https://www.lsretail.com/products/ls-central-for-retail) | [NaviWorld Việt Nam](https://naviworld.com.vn/vi/phan-mem-ban-le-ls-retail-naviworld/) có giải pháp; POS/ERP, replenishment, offline, loyalty; M; S32 |
| Oracle MICROS Simphony | [Oracle ASEAN](https://www.oracle.com/asean/food-beverage/restaurant-pos-systems/simphony-pos/) | Đã đọc sản phẩm ASEAN; chưa xác minh điều kiện cấp phép/đối tác triển khai Việt Nam; chỉ tham chiếu kiến trúc, không tính là xác nhận chào bán địa phương |

### Hệ sinh thái quanh POS, không thay thế máy tính tiền

Nhiều hãng trong khảo sát có các đầu nối dưới đây, nhưng điều kiện gói và khả năng kết nối cần xác minh từng hãng. Park Việt ưu tiên tích hợp dịch vụ thay vì tự xây lại; mức ưu tiên tuân thủ xác định trước khi đưa vào vận hành.

- Hóa đơn điện tử và chữ ký số: MISA meInvoice, VNPT Invoice, Viettel S-Invoice, cùng hóa đơn gắn trong KiotViet, Sapo, MISA eShop, POS365, Tendoo, SofiPOS.
- Vận chuyển: GHTK, GHN, Viettel Post, J&T, AhaMove, GrabExpress, và cổng vận chuyển của KiotViet hoặc Sapo.
- Thanh toán: VietQR/Napas, VNPay, MoMo, ZaloPay, thẻ. Hiện Park Việt chỉ ghi nhận khoản đã thu bên ngoài.
- Chat và mạng xã hội: Pancake, Haravan, Sapo, KiotViet cho Facebook, Zalo, Instagram.
- Sàn: Shopee, TikTok Shop, Lazada, Tiki. Sendo xuất hiện trong tài liệu Sapo cũ hơn là trọng tâm 2026.
- Kế toán: MISA AMIS, Sapo Accounting, phần kế toán hộ kinh doanh gắn POS.

### Không đưa vào danh sách làm chuẩn

- Mã nguồn mở hoặc lõi mở: Odoo Community, ERPNext, WooCommerce, Akaunting.
- Sàn và siêu app: Shopee, TikTok Shop, Lazada, Tiki. Đó là kênh bán, không phải phần mềm quản lý cửa hàng.
- Nhà cung cấp chỉ bán máy POS hoặc cài hãng khác không tự động là một sản phẩm riêng. Cần xác minh tác giả sản phẩm và tránh đếm lặp thương hiệu/gói.
- Microsoft Dynamics 365 Commerce, Shopify POS và các sản phẩm quốc tế khác: không kết luận không có tại Việt Nam; điều kiện cung cấp, thanh toán và bản địa hóa còn nằm trong backlog xác minh.

<a id="nghiep-vu"></a>

## Việc các hãng đang bán, gom theo nghiệp vụ

Cột trạng thái là Park Việt theo source đã đọc, không phải độ phổ biến thị trường. “Có” không có nghĩa là đã chạy lại test hoặc kiểm thử browser trong đợt nghiên cứu này. Những nhận định từ bản trước chưa có bài cụ thể được xem là đầu mối cần đặc tả, không phải ma trận hỗ trợ đã kiểm thử.

Nguồn hiện trạng: [POS](../app/javascript/pages/workspace/sale.tsx), [Product](../app/models/product.rb), [tính tiền](../app/models/concerns/business_document.rb), [chốt/kho](../app/services/document_workflow.rb), [khoản thu/chi](../app/services/payment_workflow.rb), [test chứng từ](../test/models/document_workflow_test.rb), [test thanh toán/nhận hàng](../test/models/payment_receiving_test.rb).

### 1. Bán tại quầy

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Tìm hàng theo tên, mã, mã vạch | KiotViet S01, Sapo S02 | Có |
| Nhiều giỏ / nhiều hóa đơn đang mở | KiotViet, POS365, Maybanhang | Có |
| Số lượng lẻ | KiotViet, Sapo | Có |
| Ghi chú hóa đơn và ghi chú từng dòng | KiotViet S01 | Có ghi chú hóa đơn; chưa có ghi chú dòng trên POS |
| Bán ghi nợ | KiotViet, Sapo, SoBanHang | Có |
| Chọn tăng nhanh số lượng; chuyển chế độ lưới ảnh/danh sách | KiotViet, TNCBASE | Có chọn tăng tối đa 1 theo tồn; chưa chuyển chế độ và chưa hiện ảnh sản phẩm trên POS |
| Nhiều bảng giá trên một hóa đơn: chung, VIP, theo nhóm khách, theo thời gian | KiotViet | Chưa |
| Thanh toán tách nhiều phương thức trên một hóa đơn | KiotViet | Một phần: ghi nhận khoản, chưa tách phương thức trên quầy |
| Tiền thừa, gợi ý mệnh giá | Nhanh S11, Haravan | Có tiền khách đưa, tính tiền thừa và nút Đủ tiền; chưa gợi ý mệnh giá |
| Kênh bán: tại quầy, Facebook, điện thoại, khác | KiotViet, Sapo | Chưa |
| Thu khác: phí giao, phí dịch vụ, VAT dạng tiền hoặc phần trăm | KiotViet | Chưa |
| Đổi ngày giờ chứng từ, khóa kỳ | KiotViet, MasterPro | Có chọn ngày chứng từ nháp; chưa khóa kỳ và chưa chọn giờ bán riêng |
| Trả hàng bán, có hạn mức thời gian trả | KiotViet, Sapo | Chưa |
| Đặt hàng khách, giao một phần, kết thúc đơn | KiotViet | Chưa |
| Sao chép hóa đơn | KiotViet | Có ở chứng từ |
| Chặn sửa chứng từ đã chốt | KiotViet | Có |
| Giữ giao dịch khi mất mạng, rồi đồng bộ khi có mạng | POS365 S18, Suno, LS Central S32 | Chưa. Giỏ chỉ nằm trong tab; chưa ghi nhận giao dịch offline |
| Cân điện tử đổ số lượng | KiotViet | Chưa |
| Lên đơn bằng giọng nói | MISA eShop, EasyPOS quảng bá | Chưa; backlog AI, phải xác nhận trước khi tạo chứng từ |

### 2. Hàng hóa và giá

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Nhóm hàng, loại, nhà sản xuất, ảnh | KiotViet, MISA eShop | Có |
| Mã hàng tự sinh và tìm theo mã | KiotViet | Có `Product#assign_code`, duy nhất trong cửa hàng; chưa tách SKU/mã vạch hoặc hỗ trợ nhiều mã |
| Thuộc tính tạo biến thể: màu, size, hương | KiotViet, MISA eShop (thời trang) | Chưa |
| Nhiều đơn vị tính trên một hàng, quy đổi | KiotViet | Chưa |
| Combo và bán kèm | KiotViet S01, Sapo S03 | Chưa; combo tồn thành phần khác gợi ý upsell |
| Hàng sản xuất từ nguyên liệu, trừ định mức khi bán | KiotViet, iPOS | Chưa |
| Giá vốn bình quân từ phiếu nhập và trả nhập | KiotViet | Chưa thành chính sách giá vốn |
| Nhiều bảng giá, nhập xuất Excel, so sánh với giá vốn | KiotViet | Chưa |
| Lô, hạn dùng, xuất gần hết hạn trước, cảnh báo cận date | KiotViet nhà thuốc, MISA eShop | Chưa |
| Serial / IMEI, bảo hành theo serial | KiotViet, MISA eShop nội thất | Chưa |
| In tem mã vạch, tem kệ | KiotViet, SoBanHang | Chưa |

### 3. Kho

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Tồn theo cửa hàng, trừ khi chốt bán, cộng khi hủy bán | KiotViet, Sapo | Có, một mức cửa hàng; hủy hiện tại chưa phải quy trình hoàn hàng giao vận |
| Tồn âm có kiểm soát, hoặc cấm bán khi hết | MISA eShop S06, Haravan S29 | Có cấm vượt tồn ở POS và server; chưa có cấu hình cho phép tồn âm |
| Nhập hàng, trả hàng nhập | KiotViet | Nhập có. Trả nhập chưa tách thành nghiệp vụ riêng |
| Đặt hàng nhập, duyệt, nhận từng phần, cấm nhận quá | KiotViet | Có |
| Chi phí cộng vào phiếu nhập: vận chuyển, thuế | KiotViet | Chưa |
| Chuyển hàng giữa kho hoặc chi nhánh | KiotViet, Sapo | Chưa. Danh mục chi nhánh có, tồn chưa theo chi nhánh |
| Nhiều kho trong một cửa hàng: kho bán, kho trữ | Sapo S03, PosApp S19 | Chưa; điều kiện gói từng hãng cần xác minh |
| Kiểm kho, điều chỉnh tăng giảm | KiotViet | Chưa |
| Xuất hủy | KiotViet | Chưa |
| Thẻ kho | KiotViet | Chưa |

### 4. Đối tác

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Khách hàng, nhà cung cấp, lịch sử giao dịch | KiotViet S01, Sapo S02, EBIZ S25 | Có |
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
| Phiếu thu, phiếu chi không gắn hóa đơn | Sapo S05 | Chưa có nghiệp vụ độc lập; `PaymentWorkflow` chỉ gắn Invoice/Purchase đã chốt |
| Mở ca, đóng ca, kiểm tiền két, doanh thu theo nhân viên ca | iPOS, CukCuk, KiotViet | Chưa |
| Đối soát sao kê hoặc báo tiền về | SoBanHang đang quảng bá loa và đối soát | Chưa |
| Cổng thanh toán thật, QR động theo số tiền hóa đơn | KiotViet Napas, iPOS ví | Chưa |
| Khóa sổ theo ngày | KiotViet | Chưa |
| Hoàn tiền khi hủy hóa đơn | Các POS tách khỏi việc hoàn kho | Chưa tự hoàn. Đúng với giới hạn hiện tại |

### 6. Khuyến mại

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Giảm giá dòng và giảm giá hóa đơn | KiotViet, Sapo, Haravan | Có giảm số tiền toàn đơn trên POS; giảm dòng có ở form chứng từ, chưa ở POS; chưa giảm % |
| Mua X tặng Y, giảm theo hóa đơn, tặng hàng, tặng điểm | KiotViet, iPOS, CukCuk | Chưa |
| Voucher, coupon, phát hành và trừ khi thanh toán | KiotViet | Chưa |
| Giá theo khung giờ, khu vực, phí dịch vụ | CukCuk, iPOS | Chưa |
| Phạm vi khuyến mại từng kênh | Sapo S04 | Chưa; tài liệu Sapo nói CTKM quầy **không áp dụng** cho đơn sàn/website đồng bộ; social chỉ hỗ trợ một số loại |

### 7. Người dùng và chuỗi

| Việc | Ai làm rõ | Park Việt |
| --- | --- | --- |
| Nhân viên, vai trò, quyền | KiotViet S01, iPOS S13, RIC | Có |
| Quyền từng thao tác nhạy cảm: xóa món, giảm giá, sửa hóa đơn | iPOS, KiotViet | Có khung quyền. Chưa gắn hết thao tác quầy |
| Nhật ký ai sửa gì | iPOS, Sapo | Chưa thành nhật ký nghiệp vụ đầy đủ |
| Nhiều chi nhánh, báo cáo gộp và tách | KiotViet, iPOS, MISA eShop | Danh mục chi nhánh có. Vận hành kho và doanh thu theo chi nhánh chưa |
| Hoa hồng, chấm công, lương | KiotViet gói chuyên nghiệp, iPOS HRM | Chưa |
| API cho đối tác | KiotViet S01, Nhanh S21, PosApp | Chưa thành sản phẩm; gói, quyền và giới hạn API cần xác minh riêng |

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
| Máy in nhiệt, két, máy quét, màn hình khách | Sapo S02, iPOS S13 | Có đường nhập mã rồi Enter cho scanner giả lập bàn phím; chưa kiểm chứng thiết bị thật hoặc tích hợp két/màn khách |
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
- Tính giờ/đặt tài nguyên: karaoke, bida, sân thể thao; tham chiếu AZPOS, PosApp, VietPOS.
- B2B/DMS: lead, báo giá, hợp đồng, tuyến sales, nhà phân phối, sell-in/out; tham chiếu Base, FAST, Viettel DMS, MobiWork.

### 13. Kho dữ liệu, vận hành và trải nghiệm

Không chỉ tính năng tạo đơn: còn import/số dư đầu kỳ, xuất dữ liệu để chuyển phần mềm, khôi phục khi lỗi, mobile, nhật ký và hướng dẫn đào tạo. Sapo S02/S03, MISA S06, BLUESOFTS S27 và Nhanh S10 là nguồn tham chiếu. Không tự nhận cloud/offline/an toàn tuyệt đối chỉ từ trang marketing.

### 14. Marketing: nội dung của hãng và công cụ cho người bán

Đã nghiên cứu thông điệp sản phẩm, nhóm ngành, gói, FAQ, ví dụ triển khai và bài hướng dẫn có liên quan; chưa đọc toàn bộ blog/YouTube của từng hãng. Nhóm tính năng cần đưa vào hệ thống gồm khuyến mại/loyalty (giai đoạn 5), chiến dịch/CRM (5–11), website/social/sàn (9), đo hiệu quả và phân khúc (6/11). Bài SEO “top phần mềm” chỉ dùng để tìm tên; nhận xét đối thủ của một hãng không phải bằng chứng độc lập.

<a id="roadmap"></a>

## Roadmap

Giữ giai đoạn 0–10 của bản trước để tránh mất checklist; bổ sung 1B và 11. Đây là thứ tự ưu tiên mặc định, **không phải chuỗi bắt buộc hoàn thành hết mỗi giai đoạn mới sang giai đoạn khác**. Bán lẻ một cửa hàng là đường chính, ngành dọc/B2B là nhánh mở rộng có điều kiện kích hoạt, không bị loại khỏi danh mục.

| Giai đoạn | Điều kiện bắt đầu | Đầu ra / cửa nghiệm thu |
| --- | --- | --- |
| 0 | Source/test hiện tại | Baseline tính năng; chạy kiểm thử lại trước khi xây phần phụ thuộc |
| 1 | 0; chọn chi nhánh cần dữ liệu tồn giai đoạn 2 | Bán, giảm giá, thu nợ, trả/đổi không lệch tiền và tồn |
| 1B | Mô hình ghi sổ/chống trùng; chốt chính sách tồn khi mất mạng | Khôi phục giỏ rồi offline thực sự; retry không nhân đôi chứng từ |
| 2 | 0; phối hợp nghiệp vụ trả hàng giai đoạn 1 | Ledger kho, kho/chi nhánh, giá vốn và chuyển/kiểm kho khớp |
| 3 | 2 cho giữ tồn/giao nhiều kho; 0 cho đơn nháp | Đặt cọc, giữ hàng, giao/hoàn một phần có dấu vết |
| 4 | 0 và mô hình payment; phối hợp split/return giai đoạn 1 | Quỹ và ca đối soát được; không bắt chờ xong 3 |
| 5 | 1; 4 nếu dùng thẻ tiền/voucher có giá trị tiền | Giá/điểm/khuyến mại có điều kiện, đảo khi trả hàng |
| 6 | Theo module: 0 cho doanh thu, 2 cho giá vốn, 4 cho dòng tiền | Báo cáo drill-down về chứng từ và phân biệt doanh thu/tiền thu |
| 7 | Loại chứng từ tương ứng đã có | Mẫu in, tem, scanner và thiết bị được xác nhận |
| 8 | Chứng từ bất biến, thuế/rounding, danh tính người mua, luồng xử lý sai sót được chốt | Sandbox nhà cung cấp và xác nhận kế toán; **có thể ưu tiên song song 1/2/4** |
| 9 | 2 + 3 + sổ payment/đối soát cần từ 4 | Một connector thật, chống trùng, hàng hoàn nhận thực tế, đối soát |
| 10 | Lõi chung và khách hàng ngành được chọn | Module ngành đã nghiệm thu; không ép triển khai tất cả ngành cùng lúc |
| 11 | Hồ sơ đối tác; 2/3 nếu nối kho/giao; 4 nếu cấn trừ tiền | Pipeline/báo giá/hợp đồng hoặc DMS có khách hàng pilot |

Mỗi mục xong khi có đường đi trên giao diện, quyền ở server, chứng từ/tiền/tồn đúng, kiểm thử thành công và người dùng nghiệm thu. Checkbox hiện có mô tả baseline được đọc từ source, không có nghĩa đợt này đã chạy app hay test lại. Không ước tính ngày hoàn thành khi chưa chốt đội ngũ, phạm vi từng đợt và thiết bị/tài khoản tích hợp.

### Giai đoạn 0 — Đang có

- [x] Đăng nhập, cửa hàng, nhân viên, vai trò, danh mục chi nhánh
- [x] Hàng hóa, nhóm, loại, nhà sản xuất, ảnh
- [x] Khách hàng, nhà cung cấp, công nợ, lịch sử
- [x] POS nhiều giỏ, số lượng lẻ, tìm tên hoặc mã, ghi chú hóa đơn, bán nợ
- [x] Giảm tiền toàn hóa đơn, tiền khách đưa/tiền thừa, nút Đủ tiền
- [x] Mã sản phẩm tự sinh; chặn bán vượt tồn ở server và POS
- [x] Hóa đơn và phiếu nhập: lọc, sao chép, chốt, hủy hoàn kho
- [x] Đặt nhập: duyệt, nhận từng phần, cấm nhận quá
- [x] Tiền tính ở server, chống thanh toán lặp, chứng từ đã chốt không sửa trực tiếp
- [x] In trình duyệt có đầu trang, cuối trang, khổ giấy
- [x] Tổng quan doanh thu và công nợ

### Giai đoạn 1 — Quầy bán dùng được cả ngày

Mục tiêu: nhân viên không phải nhảy ra quản trị để xử lý một ca bán bình thường.

- [ ] Chuyển chế độ bán danh sách/lưới ảnh; giữ hành vi chọn tăng nhanh hiện có
- [ ] Sắp xếp dòng trong giỏ
- [ ] Chọn chi nhánh bán khi tài khoản được phép
- [ ] Chọn người bán khác người đang đăng nhập, nếu quyền cho phép
- [ ] Bảng giá: ít nhất một bảng chung và một bảng theo nhóm khách
- [ ] Kênh bán gắn trên hóa đơn
- [ ] Thu khác theo số tiền hoặc phần trăm
- [ ] Tách thanh toán: tiền mặt, chuyển khoản, ghi nợ trên cùng hóa đơn
- [x] Tiền khách đưa và tiền thừa có trong baseline
- [ ] Gợi ý mệnh giá và nhập giảm giá dòng/% ngay tại POS
- [ ] Trả hàng từ một hóa đơn đã chốt, hoàn tồn, ghi nhận tiền trả
- [ ] Không cho trả quá số đã bán, trừ phần đã trả trước đó
- [ ] Menu quầy: hóa đơn trong ngày, báo cáo rút gọn; cuối ca phụ thuộc giai đoạn 4

### Giai đoạn 1B — Không mất giỏ và offline thực sự

- [ ] Khôi phục giỏ bền vững sau đóng/mở trình duyệt; tách giỏ theo user/store/quầy
- [ ] Lưu nháp server, chuyển giỏ giữa thiết bị khi online
- [ ] Cache hàng/giá/quyền có version; hàng đợi giao dịch chưa đồng bộ hiển thị rõ
- [ ] Đồng bộ lại đúng một lần, xử lý giá thay đổi, hết tồn và trùng key có thông báo
- [ ] Chính sách quyền offline hết hạn, hạn mức tồn phân bổ cho thiết bị hoặc nhận rủi ro oversell
- [ ] Không xác nhận thanh toán ngân hàng hay phát hành hóa đơn điện tử chỉ từ trạng thái offline
- [ ] Kiểm thử mất mạng, đóng tab, lỗi giữa chừng và hai thiết bị bán cùng hàng

### Giai đoạn 2 — Kho vận hành

- [ ] Tồn theo chi nhánh, không chỉ theo cửa hàng
- [x] Cấm bán vượt tồn theo chính sách hiện có
- [ ] Thêm chính sách tồn âm nếu cần; phải đổi đồng bộ model/server/POS/giá vốn, không chỉ bật UI
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
- [ ] Tích điểm theo cơ sở được chốt (tiền thực thu hay giá trị đơn), trừ/hoàn điểm khi trả hàng
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

Đánh giá nhu cầu tuân thủ **trước khi cho cửa hàng thật sử dụng**, không chờ giai đoạn 6/7 chỉ vì số thứ tự. Chặn sửa hóa đơn là cần nhưng chưa đủ; còn thuế, làm tròn, thông tin người mua và xử lý sai sót theo quy trình đang hiệu lực.

- [ ] Kế toán xác nhận đối tượng, loại hóa đơn, thuế suất và quy trình điều chỉnh/thay thế hiện hành
- [ ] Chọn một nhà cung cấp có API/tài liệu/sandbox và điều khoản phù hợp
- [ ] Hồ sơ pháp lý cửa hàng, mã số thuế, thông tin người mua và ánh xạ mặt hàng/thuế
- [ ] Phát hành từ snapshot chứng từ đã chốt, lưu trạng thái, mã tra cứu và bản thể hiện
- [ ] Chống phát hành lặp khi timeout; truy vấn trạng thái trước retry, có xử lý lỗi/manual review
- [ ] Trả hàng/sai sót đi theo quy trình điều chỉnh hoặc thay thế được xác nhận; không tự động “hủy” mọi hóa đơn
- [ ] Xuất/chuyển dữ liệu sang kế toán trước; phân hệ kê khai/sổ HKD ở checklist mở rộng sau, không xóa khỏi roadmap

### Giai đoạn 9 — Kênh ngoài cửa hàng

Làm từng kênh, tồn phải trừ một lần.

- [ ] Trạng thái đơn thống nhất: mới, chốt, đóng gói, giao, hoàn
- [ ] Một kênh đầu tiên, ưu tiên cái cửa hàng thật đang dùng
- [ ] Đồng bộ tồn khả dụng theo giữ/xuất hàng; đơn đã xuất chỉ cộng lại sau nhận hàng hoàn, không từ webhook hủy
- [ ] Đối soát tiền thu hộ
- [ ] Website catalog chỉ khi quầy và kho đã xong

### Giai đoạn 10 — Khi có ngành riêng

- [ ] FnB: bàn, bếp, món thêm
- [ ] Serial, bảo hành, lô date
- [ ] Lịch hẹn dịch vụ
- [ ] Chấm công và lương
- [ ] AI trên số liệu đã có

### Giai đoạn 11 — Bán sỉ, CRM/B2B và phân phối

- [ ] Lead/contact/account, phân sales, lịch sử tương tác và việc cần làm
- [ ] Pipeline cơ hội, lý do thắng/thua, dự báo doanh thu
- [ ] Báo giá có phiên bản, duyệt chiết khấu, chuyển thành đơn/đặt cọc
- [ ] Hợp đồng, lịch giao và lịch thanh toán, công nợ có hạn thanh toán
- [ ] Chính sách đại lý, giá theo số lượng, chiết khấu/hoa hồng
- [ ] Tuyến sales, điểm bán, pre-sales/van-sales, tồn xe, sell-in/out
- [ ] Ticket sau bán, bảo hành/sửa chữa, SLA
- [ ] Workflow/checklist mở-đóng cửa, duyệt mua/chi theo ngưỡng; tích hợp HRM/ERP khi cần

## Thứ tự không nên đảo

1. Thống nhất sổ kho và sự kiện giữ/xuất/nhận hoàn trước đồng bộ sàn. Không cộng tồn chỉ vì đơn chuyển sang “đang hoàn”.
2. Giá vốn và phân bổ chiết khấu trước báo cáo lãi gộp; chi phí hoạt động trước báo cáo lãi ròng.
3. Mô hình khoản tiền/đối soát trước xác nhận thanh toán tự động. Ca và quỹ có thể làm song song, không cần chờ mọi nghiệp vụ giao hàng.
4. Đánh giá tuân thủ ngay từ đầu; hóa đơn điện tử không phụ thuộc báo cáo lãi hay chương trình loyalty. Nhánh 8 được ưu tiên khi cửa hàng cần.
5. AI giao dịch chỉ sau quyền, snapshot, audit và xác nhận người dùng; không tự phát hành, hoàn tiền hoặc gửi marketing hàng loạt.
6. Ngành dọc, CRM và chat vẫn được giữ trong backlog đầy đủ; chỉ thứ tự giao phụ thuộc nhu cầu pilot, không bị cắt vì lõi bán lẻ ưu tiên trước.

<a id="checklist-mo-rong"></a>

## Checklist bổ sung có mã công việc

Đây là **backlog hợp nhất**, không phải tuyên bố mọi hãng có mọi tính năng. `G` là giai đoạn đích, `S` là nguồn bên dưới. Các mục dưới đây bổ sung/chi tiết hóa checklist giai đoạn, không thay thế checkbox baseline. Mã được giữ ổn định để tạo issue sau; chưa tạo issue, chưa gán sprint hoặc đánh dấu triển khai.

Những ràng buộc như chống trùng, snapshot, kiểm quyền, consent và phục hồi là đề xuất kỹ thuật Park Việt để làm nghiệp vụ an toàn; không gán chúng cho hãng nếu nguồn chỉ mô tả tính năng. Khi làm một mục: đọc bài nguồn, chốt quy tắc với cửa hàng, chọn test hẹp, triển khai rồi mới đánh dấu xong.

### Quầy, chứng từ, trả/đổi

- [ ] POS-01 — G1: tìm có dấu/không dấu, mã chính xác, lọc nhóm, hàng yêu thích, phím tắt, grid ảnh/list. Nguồn S01/S29.
- [ ] POS-02 — G1: ghi chú dòng, đổi giá/giảm tiền hoặc %, thứ tự dòng, lưu lý do và kiểm quyền. Nguồn S01/S29.
- [ ] POS-03 — G1: tạo/tìm khách tại quầy không mất giỏ; xem nợ, nhóm và quyền ưu đãi trước checkout. Nguồn S01/S29.
- [ ] POS-04 — G1/2: chi nhánh/quầy/nhân viên bán; người thao tác khác người hưởng doanh số, snapshot vào hóa đơn. Nguồn S13/S29.
- [ ] POS-05 — G1: phụ thu/giảm phí, thuế theo dòng, giá đã/chưa gồm thuế; quy tắc làm tròn và phân bổ giảm toàn đơn. Nguồn S06/S29; thuế phải xác nhận riêng.
- [ ] POS-06 — G1/4: tách nhiều khoản tiền theo phương thức/tài khoản; số còn nợ không là phương thức thanh toán. Nguồn S13/S19/S30.
- [ ] POS-07 — G1: tạm tính, lưu nháp, sao chép, tìm chứng từ theo mã/khách/điện thoại; không nhân đôi payment khi gửi lại. Nguồn S07/S29.
- [ ] RET-01 — G1: phiếu trả tham chiếu dòng bán, số còn được trả, lý do, hạn trả; xử lý đơn có khuyến mại/quà tặng. Nguồn S07/S06.
- [ ] RET-02 — G1/4: tách nhận hàng với hoàn tiền/cấn nợ; giới hạn hoàn theo khoản thực thu, tình trạng hoàn pending/failed/done. Nguồn S07/S08.
- [ ] RET-03 — G1/2: đổi sản phẩm khác, thu/trả chênh lệch; hoàn giá sau phân bổ giảm và đúng giá vốn gốc. Nguồn S07/S06.
- [ ] RET-04 — G2/5: trả khác chi nhánh, hàng lỗi không đưa vào tồn bán được; đảo điểm/voucher theo chính sách. Nguồn S07/S09/S10.
- [ ] RET-05 — G1/4: trả không tìm được hóa đơn gốc là nhánh riêng, cần quyền/duyệt và chứng minh mua; không giả định giá vốn/thuế/điểm từ đơn cũ. Nguồn S40/S41.
- [ ] RET-06 — G1/8: chặn hủy đơn gốc đã có trả hàng; đảo phiếu trả và tiền/điểm theo chuỗi chứng từ, khóa khi HĐĐT liên quan đã phát hành. Nguồn S41; quy tắc Park Việt cần kế toán duyệt.

### Hàng hóa, giá và mua hàng

- [ ] CAT-01 — G2: product cha/biến thể màu-size, SKU riêng, nhiều mã vạch, quy tắc trùng mã và chuyển đổi mã cũ. Nguồn S03/S06/S16.
- [ ] CAT-02 — G2: đơn vị cơ sở/đơn vị nhập-bán, tỷ lệ quy đổi, mã/giá từng đơn vị, độ chính xác số lượng; version tỷ lệ đã giao dịch, không sửa hồi tố. Nguồn S03/S06/S27/S37.
- [ ] CAT-03 — G2/10: phân loại hàng tồn, dịch vụ không tồn, combo ảo và gói đóng sẵn; trả combo theo cấu phần. Nguồn S01/S03/S10.
- [ ] CAT-04 — G2: trọng lượng/kích thước giao hàng, vị trí kệ, tag, ảnh/mô tả, trạng thái mở/ngừng bán theo kênh. Nguồn S16/S10.
- [ ] CAT-05 — G1/5: giá nhóm khách/đại lý, bậc số lượng, chi nhánh, thời gian; precedence và giữ giá chứng từ cũ. Nguồn S01/S26/S27.
- [ ] CAT-06 — G2/5: import/export bảng giá, sửa hàng loạt, quyền xem giá vốn và cảnh báo bán dưới giá vốn. Nguồn S03/S01.
- [ ] PUR-01 — G2: hạn giao, lịch nhận nhiều lần, lô/serial từng lần; kế thừa cơ chế nhận từng phần đang có. Nguồn S03/S10.
- [ ] PUR-02 — G2: trả nhập theo phiếu gốc, giới hạn lượng chưa trả, giảm nợ NCC/ghi tiền nhận lại. Nguồn S03/S23.
- [ ] PUR-03 — G2: phân bổ chi phí mua/vận chuyển và thuế không được khấu trừ; xử lý chiết khấu sau nhập có audit. Nguồn S03/S33; chính sách điều chỉnh cần kế toán duyệt.
- [ ] PUR-04 — G2/11: đề xuất mua, so sánh báo giá NCC, duyệt theo ngưỡng, minimum/lead time và lịch sử giá mua. Nguồn S17/S27; phần ngưỡng là đề xuất.

### Kho, giá vốn và chuỗi

- [ ] INV-01 — G2: kho/chi nhánh/vị trí và sổ biến động có chứng từ; số dư đầu, nhập/xuất/điều chỉnh không sửa tồn tùy ý. Nguồn S03/S10/S27.
- [ ] INV-02 — G2/3: tồn vật lý, tạm giữ, khả dụng, lỗi/cách ly và đang chuyển; cấu hình ngưỡng min/max. Nguồn S10/S06.
- [ ] INV-03 — G2: kiểm toàn kho/theo nhóm/cycle count, scan/import, nháp/duyệt/bù chênh; xử lý bán trong lúc kiểm. Nguồn S10.
- [ ] INV-04 — G2: chuyển kho xuất/đang đi/nhận thiếu/nhận đủ; xác nhận nhận độc lập, đối soát hàng mất. Nguồn S03/S08.
- [ ] INV-05 — G2: xuất hủy/xuất dùng nội bộ, lý do, người duyệt và chi phí hao hụt; tách khỏi bán hàng. Nguồn S01/S24.
- [ ] INV-06 — G2: thẻ kho và báo cáo nhập-xuất-tồn drill-down; đối chiếu tổng sổ với tồn và chứng từ. Nguồn S03/S27.
- [ ] INV-07 — G2: giá vốn bình quân sau nhập, snapshot giá vốn xuất; trả bán theo xuất gốc, trả mua/chuyển và backdate có chính sách. Nguồn S06/S33.
- [ ] INV-08 — G2/10: đánh giá FIFO/đích danh nếu ngành cần; phân biệt FIFO giá vốn và FEFO chọn lô hạn gần. Nguồn S27/S06; không mặc nhiên triển khai LIFO vì hãng quảng bá.
- [ ] INV-09 — G2: cảnh báo tồn thấp/vượt định mức/hàng chậm, đề xuất nhập/điều chuyển, hạn mức tồn theo kho. Nguồn S03/S32.
- [ ] INV-10 — G2: gọi hàng kho khác, chia kho tổng theo tỷ lệ hoặc target tồn, import nhiều kho; quy tắc làm tròn và tổng lượng phân phối phải bảo toàn. Nguồn S39.
- [ ] INV-11 — G2/6: dự báo nhu cầu từ tốc độ bán, tồn khả dụng/đang về/minimum/lead time; gợi ý có giải thích, không tự coi là AI hoặc đơn mua đã duyệt. Nguồn S39.
- [ ] CHN-01 — G2/5: danh mục/giá tập trung, quyền theo chi nhánh/nhóm chi nhánh, đồng bộ có lịch áp dụng. Nguồn S13/S18.
- [ ] CHN-02 — G6: doanh thu/tồn/tiền tách và hợp nhất; chuyển nội bộ không tính thành doanh thu bán khách. Nguồn S13/S32.
- [ ] CHN-03 — G10/11: nhiều thương hiệu/pháp nhân; ghi rõ giao dịch nội bộ khác pháp nhân trước hợp nhất. Nguồn S27/S32; chính sách pháp nhân cần thiết kế riêng.

### Đơn trước, giao vận và đối soát

- [ ] ORD-01 — G3: báo giá/đơn đặt, cọc, hạn giữ hàng, đơn giao một phần, phần còn thiếu và hủy phần còn lại. Nguồn S01/S15/S17.
- [ ] ORD-02 — G3/9: trạng thái bán/thanh toán/giao hàng riêng; lịch hẹn giao, nhiều địa chỉ/kiện, pickup tại shop. Nguồn S12/S13.
- [ ] ORD-03 — G3/9: phiếu nhặt/đóng gói, quét đối chiếu SKU, bàn giao vận chuyển; ảnh/video bằng chứng khi có nhu cầu. Nguồn S12/S20; video là tham chiếu marketing VietPOS.
- [ ] SHP-01 — G9: một hãng vận chuyển trước; phí, COD, tài khoản shop, mã vận đơn, nhãn và webhook. Nguồn S21/S22.
- [ ] SHP-02 — G9: giao thất bại, ký nhận một phần, đang hoàn/đã nhận hoàn; xác nhận mất/hỏng và khiếu nại. Nguồn S12/S15.
- [ ] SHP-03 — G9: đối soát COD, cước/hoàn/các khoản khấu trừ và bảng kê; chặn quyết toán lặp. Nguồn S12/S22.
- [ ] SHP-04 — G9: dữ liệu địa chỉ hành chính cập nhật, mapping mã vùng nhà vận chuyển; không suy ra theo tên tỉnh cũ. Nguồn S01/S21.

### Tiền, quỹ, ca và công nợ

- [ ] FIN-01 — G4: tài khoản quỹ/ngân hàng, số dư đầu, phiếu thu/chi độc lập, loại khoản tiền, chứng từ đính kèm. Nguồn S05/S19.
- [ ] FIN-02 — G4: chuyển quỹ hai vế cân bằng, nộp/rút két, cọc khách/NCC, đối trừ và số dư có chứng từ. Nguồn S05/S19; đối trừ là đề xuất cần kế toán duyệt.
- [ ] FIN-03 — G4: mở ca/quầy/thu ngân, tiền đầu/đếm cuối, rút giữa ca, trả tiền mặt, chênh lệch và bàn giao. Nguồn S11/S13/S30.
- [ ] FIN-04 — G4: kỳ khóa, mở khóa có quyền/lý do, phiếu điều chỉnh thay sửa số đã khóa. Nguồn MasterPro, S27.
- [ ] FIN-05 — G4/9: QR động có amount/reference/expiry; trạng thái chờ/xác nhận/thất bại, webhook xác thực/chống lặp. Nguồn S29; chi tiết bảo vệ là đề xuất.
- [ ] FIN-06 — G4/9: ghép sao kê theo mã/số tiền, xử lý thiếu-thừa/không khớp, số dư cổng/thẻ/COD chờ về. Nguồn S12/S20/S29.
- [ ] FIN-07 — G4: payment/refund ledger đối chiếu hóa đơn/phiếu trả, không xóa lịch sử hoặc hiểu tiền khách đưa là doanh thu. Nguồn S07/S11.
- [ ] DEBT-01 — G5/11: hạn mức/thời hạn, nợ đầu kỳ, tuổi nợ, chặn bán nợ theo quyền, xác nhận công nợ. Nguồn S01/S27.
- [ ] DEBT-02 — G4/5: một khoản thu phân bổ nhiều hóa đơn, trả trước chưa phân bổ, thanh toán NCC từng phần, nhắc nợ. Nguồn S05/S27; cơ chế phân bổ là đặc tả đề xuất.

### Khuyến mại, loyalty, CRM và marketing

- [ ] MKT-01 — G5: giảm tiền/% theo dòng/đơn/nhóm, bậc giá trị, X tặng Y, mua combo; điều kiện ngày/giờ/khách/kênh. Nguồn S01/S04.
- [ ] MKT-02 — G5: thứ tự ưu tiên/cộng dồn/loại trừ, ngân sách/số lần, phân bổ giảm vào dòng để trả hàng đúng. Nguồn S04/S07/S09.
- [ ] MKT-03 — G5: coupon điều kiện/lần dùng/hạn/người dùng; voucher quà tặng có số dư phải tách mã giảm giá, version điều kiện sau kích hoạt. Nguồn S01/S04/S19/S37.
- [ ] MKT-05 — G3/5: nợ quà tặng gắn hóa đơn, giao bù từng phần, còn nợ/đã giao và xử lý khi trả hàng chính. Nguồn S40.
- [ ] MKT-06 — G1/5: phụ thu theo tiền/%/phương thức-quỹ, cộng trên giá gốc hay lần lượt và hiển thị lý do trên bill. Nguồn S35/S36.
- [ ] MKT-04 — G5: thẻ trả trước, nạp/dùng/hoàn/hết hạn; tách nghĩa vụ tiền khách với doanh thu dịch vụ. Nguồn PosApp/Myspa/SalonHero; kế toán phải chốt.
- [ ] LOY-01 — G5: ledger điểm cộng/trừ/đổi/hết hạn, pending sau thời hạn trả, giới hạn giảm bằng điểm. Nguồn S09.
- [ ] LOY-02 — G5: hạng theo chi tiêu/chu kỳ, hệ số kênh/chi nhánh; giữ quy tắc tại giao dịch gốc khi thu nợ sau. Nguồn S09.
- [ ] CRM-01 — G5/11: hồ sơ khách hợp nhất, nhận diện/gộp trùng có kiểm soát, nhóm/tag/RFM, lịch sử tương tác/đơn. Nguồn S09/S16/S17; RFM cần đặc tả riêng.
- [ ] CRM-02 — G5/9: consent theo kênh, từ chối nhận tin, hạn mức/tần suất, template ZNS và audit chiến dịch. Nguồn S09/S16; consent là yêu cầu Park Việt, không khẳng định hãng đã làm đầy đủ.
- [ ] CRM-03 — G5/9: sinh nhật, nhắc điểm/hẹn/nợ, win-back; email/SMS/Zalo OA từng connector có kết quả gửi/lỗi. Nguồn S09/S16.
- [ ] CRM-04 — G6/9: chi phí/nguồn chiến dịch, conversion/AOV/khách quay lại; phân biệt attribution với doanh thu chắc chắn. Nguồn S09/S20.
- [ ] CRM-05 — G11: ticket/khiếu nại, SLA, nhiệm vụ chăm sóc, đánh giá dịch vụ và tài liệu hỗ trợ. Nguồn S17, Faceworks, BMS.

### Báo cáo và điều hành

- [ ] BI-01 — G6: bán gộp/giảm/trả/doanh thu thuần, thu tiền/nợ mới/thu nợ riêng; định nghĩa ngày và timezone. Nguồn S03/S11/S13.
- [ ] BI-02 — G6: theo SKU/biến thể/nhóm/NCC, nhân viên/khách/chi nhánh/quầy/kênh/giờ, so kỳ và top hàng. Nguồn S03/S13/S27.
- [ ] BI-03 — G6: lãi gộp từ giá vốn xuất đã snapshot; lãi ròng thêm chi phí, phí sàn/vận chuyển và phân bổ. Nguồn S12/S27/S33.
- [ ] BI-04 — G6: tuổi tồn, vòng quay, cận date, chậm bán, hàng đang chuyển/giữ/lỗi; giá trị tồn và dự báo nhập. Nguồn S03/S10/S32.
- [ ] BI-05 — G6: tuổi nợ KH/NCC, dòng tiền, đối soát chưa khớp, chênh ca và lịch sử hoàn tiền. Nguồn S05/S11/S27.
- [ ] BI-06 — G6: quyền xem/export, filter lưu, drill-down về phiếu, CSV/Excel/PDF và gửi báo cáo định kỳ. Nguồn S03/S27; gửi định kỳ cần đặc tả.

### In, thiết bị, mobile và khả năng phục hồi

- [ ] DEV-01 — G7: bill 58/80mm/A4, tạm tính/hóa đơn/trả/nhập/chuyển/ca, số bản và bản in lại có nhận diện. Nguồn S02/S07/S11.
- [ ] DEV-02 — G7: barcode theo SKU/đơn vị, tem giá/kệ/lô, hàng loạt; scan camera và scanner bàn phím. Nguồn S03/S06/S16.
- [ ] DEV-03 — G7/10: máy in LAN/USB/Bluetooth qua giải pháp phù hợp, hàng đợi in/retry, két/màn khách/cân. Nguồn S02/S13/S26.
- [ ] DEV-04 — G1/6/10: POS responsive cho touch/mobile, dashboard chủ từ xa, thông báo có quyền; app native là lựa chọn sau. Nguồn S18/S29, Myspa.
- [ ] OFF-01 — G1B: phục hồi giỏ/server draft, hàng đợi offline, dữ liệu cache có version và trạng thái chưa gửi. Nguồn S18/S32, Suno/TNCBASE.
- [ ] OFF-02 — G1B: quyết định hạn mức từng thiết bị/chi nhánh, hết tồn/giá đổi/quyền thu hồi; không hứa chống oversell tuyệt đối khi offline. Nguồn S18/S32 gợi nhu cầu, thiết kế do Park Việt chọn.
- [ ] OFF-03 — G1B: reconcile sau reconnect; không trùng kho/payment/loyalty, không in thành bill đã đồng bộ khi còn lỗi. Nguồn S18; tiêu chí là đề xuất kỹ thuật.

### Dữ liệu, quyền, tích hợp và tuân thủ

- [ ] DATA-01 — G1/2: Excel/CSV import hàng/khách/NCC/số dư; preview, lỗi từng dòng, trùng mã, batch rollback và backup trước ghi. Nguồn S03/S16/S27.
- [ ] DATA-02 — G2: công cụ migrate từ export của hãng, ánh xạ SKU/đơn vị/khách/kho và đối chiếu số dư; không lấy database trái quyền. Nguồn S06/S27; connector migrate là đề xuất.
- [ ] DATA-03 — G4/9: export dữ liệu thuộc cửa hàng, chính sách lưu/ẩn danh, restore thử nghiệm và hướng dẫn rời hệ thống. Nguồn S27; retention/quyền dữ liệu cần quyết định riêng.
- [ ] SEC-01 — G1/4: quyền thao tác nhạy cảm ở server, duyệt override giá/hoàn/chi, audit trước-sau/lý do. Nguồn S13/S17/S29; **quyền và audit phải giao cùng chức năng nhạy cảm, không đợi giai đoạn 4**.
- [ ] SEC-02 — G4: quyền dữ liệu theo chi nhánh/nhóm, ẩn giá vốn, giới hạn export, phiên/thiết bị và xác thực hai lớp. Nguồn S17/S23; chính sách phiên là đề xuất.
- [ ] API-01 — G9: API sản phẩm/đơn/kho/khách/payment; quyền scope, version, rate limit và webhook có chữ ký. Nguồn S21; không copy API hãng làm contract Park Việt.
- [ ] API-02 — G9: OAuth/token quay vòng, queue/retry/backoff, khóa chống trùng, replay có audit, dead-letter và dashboard sync lỗi. Nguồn S21 gợi tích hợp, yêu cầu vận hành là đề xuất.
- [ ] TAX-01 — G8: phân loại hóa đơn/thuế, hồ sơ người mua/bán, chữ ký/cấp quyền; kiểm với kế toán và văn bản hiệu lực. Nguồn S28/S30 chỉ là tham chiếu sản phẩm.
- [ ] TAX-02 — G8: phát hành/lưu/tra cứu/gửi khách, mapping thuế và snapshot; timeout/retry/trạng thái phải chống phát hành lặp. Nguồn S28.
- [ ] TAX-03 — G8: điều chỉnh/thay thế/sai sót/trả hàng; liên kết hóa đơn gốc và số liệu trước-sau đúng quy trình được duyệt. Nguồn S02/S28, chưa xác minh quy định pháp luật.
- [ ] TAX-04 — G8 mở rộng: xuất chứng từ sang kế toán/sổ HKD; đối chiếu hóa đơn-bán hàng-payment, lịch sử sửa. Nguồn S01/S06/S28.
- [ ] TAX-05 — G8 mở rộng: sổ/tờ khai/mẫu/thuế suất theo phiên bản quy định; tài sản/chi phí trả trước khi thực sự cần, ưu tiên tích hợp. Nguồn S01; chưa chốt build thay vì integrate.

### Website, social và sàn

- [ ] OMNI-01 — G9: ánh xạ SKU/biến thể/combo, nhiều shop, kho xuất mặc định, giá/tồn dành cho kênh và lịch sync. Nguồn S06/S20/S21.
- [ ] OMNI-02 — G9: nhập đơn đúng một lần, sửa/hủy/fulfillment riêng với payment; webhook muộn/đảo thứ tự có reconcile. Nguồn S08/S12/S21; xử lý sự kiện là đề xuất.
- [ ] OMNI-03 — G9: hóa đơn/phí/khuyến mại trợ giá theo sàn; đối soát settlement, phí ads, hàng mất/hoàn. Nguồn S04/S12.
- [ ] WEB-01 — G9: catalog/giỏ/checkout/pickup/giao hàng, SEO sản phẩm, domain riêng, tồn và giá chung có phân quyền xuất bản. Nguồn S16/S32.
- [ ] WEB-02 — G9: tìm kiếm/lọc, ảnh/video, ưu đãi, tracking đơn, wishlist/đánh giá và bán thêm. Nguồn S16; wishlist/đánh giá phải khảo sát riêng.
- [ ] SOC-01 — G9: inbox/comment đa fanpage, giao hội thoại, tag/tránh trùng sales, tạo đơn và lịch sử khách. Nguồn S20/S22, TrustSales.
- [ ] SOC-02 — G9: livestream cú pháp-SKU, gộp comment, xác nhận khách, link checkout và quản lý hết tồn. Nguồn S22/S23.
- [ ] SOC-03 — G9: Zalo OA/ZNS/Mini App, Messenger, kênh bổ sung theo API được phép; không giả lập để né hạn chế nền tảng. Nguồn S09/S20.
- [ ] SOC-04 — G6/9: Meta/Google event, conversion dedup, theo dõi consent và doanh thu sau hoàn, không gửi PII tùy tiện. Nguồn S20/S22; bảo vệ dữ liệu là yêu cầu Park Việt.

### Ngành dọc, CRM/B2B, DMS, nhân sự và AI

- [ ] FNB-01 — G10: khu vực/bàn, đặt bàn/waitlist, chuyển-tách-gộp bàn, phục vụ tại bàn/quầy/mang về. Nguồn S13/S14.
- [ ] FNB-02 — G10: modifier/topping/size, course, món hết, số lượng cân, gọi thêm/hủy có lý do, bill tách khách. Nguồn S13/S14.
- [ ] FNB-03 — G10: printer routing bếp/bar, KDS nhận-đang làm-xong, ưu tiên/thời gian, tránh gửi trùng order. Nguồn S13/S14.
- [ ] FNB-04 — G10: recipe/BOM/định mức, sơ chế/yield, waste, tồn lý thuyết/thực tế và food cost. Nguồn S01/S13/S24; yield cần đặc tả riêng.
- [ ] FNB-05 — G9/10: QR order/kiosk/web order, giờ mở/bán, pickup/delivery; GrabFood/ShopeeFood theo hợp đồng. Nguồn S13/S14.
- [ ] PHAR-01 — G10: hoạt chất/hàm lượng/số đăng ký, đơn thuốc, lô/date, truy xuất và kết nối dược theo chuẩn hiệu lực. Nguồn S01/S03/S31.
- [ ] LOT-01 — G2/10: lô/HSD/số tồn, FEFO/cận date/quá hạn, recall lô và kiểm lô; không coi có lô là đạt GPP. Nguồn S06/S31; recall cần khảo sát riêng.
- [ ] SER-01 — G10: serial/IMEI duy nhất, nhập-bán-trả, bảo hành theo serial, sửa chữa/linh kiện, máy đổi/cho mượn. Nguồn S03/S25; cho mượn cần khảo sát riêng.
- [ ] SPA-01 — G10: lịch khách/nhân viên/phòng, nhắc/no-show/cọc, liệu trình số buổi, thẻ tiền, hồ sơ ảnh được cấp quyền. Nguồn Myspa/SalonHero.
- [ ] HOTEL-01 — G10: phòng/rate theo giờ-ngày, check-in/out, cọc/folio, housekeeping, dịch vụ và channel OTA. Nguồn chỉ mục KiotViet Hotel; luồng chi tiết chưa đọc.
- [ ] TIME-01 — G10: karaoke/bida/sân, lịch đặt tài nguyên, tính giờ/khung giá, pause/gói/đồ bán kèm. Nguồn AZPOS/PosApp/VietPOS; quy tắc pause cần chốt.
- [ ] SPEC-01 — G10: vật liệu theo mét/tấm/kg, gas/bao bì đặt cọc-vỏ thu hồi, cho thuê/công cụ; chọn module khi có pilot. Nguồn S26, catalog EBIZ/S10; chưa có đặc tả hoàn chỉnh.
- [ ] B2B-01 — G11: account/contact/lead, chia sales, pipeline, follow-up, thắng/thua và forecast. Nguồn S17, Getfly/Faceworks.
- [ ] B2B-02 — G11: báo giá version, thuế/chiết khấu/duyệt, hợp đồng, hạn mức nợ, lịch giao/thu và chuyển PO/sales order. Nguồn S17/S27.
- [ ] B2B-03 — G2/11: cơ hội/đơn sales tạo nhiều yêu cầu mua; mapping trường, theo dõi duyệt/trả lại/hủy và lượng đã nhận, không gộp trạng thái duyệt với nhận hàng. Nguồn S43.
- [ ] DMS-01 — G11: đại lý/NPP/địa bàn, pre-sales/van-sales, tuyến/tần suất, check-in GPS có đồng ý và đặt hàng. Nguồn Viettel DMS/MobiWork/FAST; privacy là yêu cầu Park Việt.
- [ ] DMS-02 — G11: sell-in/out, tồn xe/NPP, trade promotion/trưng bày/ngân sách, KPI và hoa hồng. Nguồn Viettel DMS/MobiWork.
- [ ] HR-01 — G10/11: ca/lịch/chấm công, hoa hồng theo sản phẩm/dịch vụ, đảo hoa hồng khi trả, bảng lương và tích hợp HRM. Nguồn S01/S13, Myspa.
- [ ] OPS-01 — G11: checklist mở-đóng cửa, duyệt mua/chi theo ngưỡng, SOP/đào tạo và giao việc liên bộ phận. Nguồn Base/Faceworks; không tự xây ERP đầy đủ trước nhu cầu.
- [ ] AI-01 — G10/11: gợi ý mô tả/giọng nói lên đơn, hỏi số liệu có dẫn chứng và theo quyền; người dùng xác nhận trước ghi. Nguồn MISA eShop/Tendoo/NextX/EasyPOS quảng bá.
- [ ] AI-02 — G10/11: gợi ý nhập/chăm sóc, tóm tắt hội thoại và chuyển người; không tự gửi hàng loạt/phát hành/hoàn tiền. Nguồn NextX/Pancake/Tendoo; rào chắn là đề xuất.

### Điều kiện nghiệm thu chung khi thực hiện dần

- [ ] AC-01 — Mục triển khai có quy tắc đầu vào/đầu ra, quyền, trạng thái và xử lý sai/hủy/hoàn được chốt; nguồn không thay thế quyết định sản phẩm.
- [ ] AC-02 — Tiền/tồn/điểm có snapshot và đối soát; gửi lại request không nhân đôi; hai thao tác đồng thời không phá hạn mức.
- [ ] AC-03 — Có luồng UI thật và test đúng hành vi vừa đổi; chạy test hẹp theo [quy tắc dự án](../AGENTS.md), không chạy toàn suite/browser khi chưa được yêu cầu.
- [ ] AC-04 — Mọi migration/import thay dữ liệu có backup, diễn tập khôi phục và rollout/rollback; không tự restart server RubyMine.
- [ ] AC-05 — Connector đã có sandbox/điều khoản/quyền hợp lệ, xử lý rate limit/token hết hạn/webhook replay và lỗi một phần.
- [ ] AC-06 — Người dùng pilot xác nhận bằng chứng số liệu và thiết bị cần dùng; docs/help hướng dẫn đúng phần đã giao.

<a id="nguon"></a>

## Nguồn chính thức để đặc tả

Các nguồn được truy cập ngày 12/10/2026. `N` là nội dung nghiệp vụ đọc được (có thể trích đoạn với bài dài), `I` là chỉ mục, `M` là thông điệp/giải pháp của hãng. Không dùng số người dùng, SLA hay lời “100% an toàn” để xếp hạng chất lượng.

| Mã | Nguồn đã đọc | Dùng để rút tính năng / giới hạn |
| --- | --- | --- |
| S01 | [KiotViet Retail: tổng quan nhóm giải pháp](https://www.kiotviet.vn/huong-dan-su-dung-kiotviet/retail-he-thong-giai-phap-kiotviet/) | N/I: quầy, kho, chuyên ngành, giá, CRM, API và thuế; trang dài đọc phần liên quan |
| S02 | [Trung tâm trợ giúp Sapo](https://help.sapo.vn/) | I: Omni/OmniAI/FnB/thiết bị/kế toán; không đồng nhất tính năng các phiên bản |
| S03 | [Sapo: sản phẩm và kho](https://help.sapo.vn/tong-quan-cac-tinh-nang-quan-ly-san-pham-kho-hang) | N/I: combo, serial/lô, nhập/trả, kiểm/chuyển, giá vốn và báo cáo |
| S04 | [Sapo: ứng dụng khuyến mại](https://help.sapo.vn/tong-quan-ve-ung-dung-khuyen-mai) | N: chương trình, coupon; giới hạn áp dụng sàn/website/social |
| S05 | [Sapo: sổ quỹ, thu chi](https://help.sapo.vn/tong-quan-ve-so-quy-quan-ly-dong-tien-thu-chi) | N/I: phiếu độc lập, loại thu/chi, in/export/hủy |
| S06 | [MISA eShop: thiết lập chung](https://helpeshop.misa.vn/kb/thiet-lap-thong-tin-chung) | N: tồn/giá xuất, trả lại, lô, nhiều mã, kho theo kênh; đọc phần kho/bán |
| S07 | [Haravan: hủy, đổi trả POS](https://help.haravan.com/docs/pos/returns/tra-cuu-huy-va-doi-tra-don-hang-tren-haravan-pos/) | N: trả nhiều lần, khác chi nhánh, chênh lệch, chia giảm giá |
| S08 | [Haravan: tồn sau hủy/hoàn sàn](https://help.haravan.com/docs/inventory/advanced-mode/cap-nhat-ton-kho-sau-khi-don-hang-bi-huy-hoac-hoan-tra-tren-kenh-tmdt/) | N: hàng xuất chỉ cộng lại sau nhận thực; khác hủy trước giao |
| S09 | [Haravan: điểm thưởng](https://help.haravan.com/docs/customers/membership-tier/thiet-lap-chuong-trinh-tich-diem-doi-thuong-trong-muc-khach-hang-trang-admin-myharavan/) | N: pending/expiry, hạn mức đổi, hệ số, lịch sử và phần tiền thu sau |
| S10 | [Nhanh: kiểm kho](https://pos.manual.nhanh.vn/pos/kho-hang/kiem-kho.md) | N: loại kiểm, tạm giữ/lỗi, snapshot và hoạt động trong lúc kiểm; chưa đọc hết phần cuối |
| S11 | [Nhanh: kết ca](https://pos.manual.nhanh.vn/pos/kenh-ban/cua-hang/ket-ca.md) | N: tiền vào ca, chi phí, bàn giao, báo cáo; đọc phần quy trình |
| S12 | [Nhanh: trả/hoàn tiền đơn sàn](https://pos.manual.nhanh.vn/pos/kenh-ban/tai-chinh-san-tmdt/tra-hang-hoan-tien-don-san.md) | N: chờ xử lý, đang hoàn, nhận hoàn một phần, thất lạc/khiếu nại |
| S13 | [iPOS FABi](https://ipos.vn/phan-mem-quan-ly-ban-hang-ipos-fabi/) | M: bàn, topping, KDS, ca, audit, chuỗi, food app |
| S14 | [CukCuk: nghiệp vụ nhà hàng](https://helpv2.cukcuk.vn/vi/ac/huong-dan-nghiep-vu-cho-nha-hang-vua-va-lon) | I: lễ tân, phục vụ, thu ngân, bếp, cân, chấm công |
| S15 | [UPOS: ký nhận một phần](https://mhelp.upos.vn/van-chuyen/ky-nhan-1-phan.md) | N: danh sách, lọc, export, hành trình vận đơn; không suy ra thuật toán hoàn tiền |
| S16 | [Salekit: quản lý sản phẩm](https://help.salekit.com/san-pham.html) | N: biến thể, trọng lượng, SEO, import/export, tem, upsell |
| S17 | [Base CRM](https://base.vn/crm), [CRM Sales help](https://help.base.vn/support/solutions/folders/63000239062) | M/I: account/contact/deal, pipeline, phân khúc, báo giá/hợp đồng |
| S18 | [POS365](https://www.pos365.vn/) | M: offline, ca, chuỗi, thiết bị, hóa đơn; chưa thử mất mạng |
| S19 | [PosApp: quỹ tiền/ví](https://retail-docs.posapp.vn/quan-ly-thu-chi/tao-vi.md) | N: loại quỹ/phương thức/chi nhánh; không áp nguyên mô hình ledger của hãng |
| S20 | [Pancake POS](https://pos.pancake.vn/), [docs](https://docs.pancake.biz/) | M/I: social, telesales, shipping, QR, Meta/Google; docs chỉ trích được phần ngắn |
| S21 | [Nhanh Open API](https://developers.nhanh.group/) | I: POS/Vpage/Ship/WebApp; endpoint/auth/webhook chi tiết chưa đọc |
| S22 | [TPos: mục hướng dẫn](https://tpos.vn/blog/huong-dan) | I: GHN/COD, CAPI, TPage, sản phẩm, báo cáo |
| S23 | [UPOS: chỉ mục đầy đủ mobile](https://mhelp.upos.vn/llms.txt) | I: đơn, kho, trả nhập, vận chuyển, 2FA; không phải đọc hết bài |
| S24 | [DanTriSoft: bản quyền theo gói](https://dantrisoft.com.vn/bang-gia/) | M: POS/kho/thu chi/định lượng/VIP; phân hệ khác theo gói |
| S25 | [EbizStore](https://www.e-biz.com.vn/san-pham/phan-mem-quan-ly-ban-hang-cua-hang-ebizstore) | M: local/chuỗi, đa đơn vị, loyalty, kho, bảo hành, thiết bị |
| S26 | [Winta POS](https://www.winta.com.vn/branch/165/phan-he-phan-mem-quan-ly-ban-le-phan-mem-pos-winta.html) | M: kích thước, cân, giá, multi-unit, giao hàng; chưa xác minh phiên bản |
| S27 | [BLUESOFTS BS GOGO](https://bluesofts.net/giai-phap-phan-mem/phan-mem-quan-ly-ban-hang-bs-gogo.html) | M: báo giá, giá xuất kho, đa tiền/đơn vị, import số dư, drill-down |
| S28 | [EasyPOS](https://easypos.vn/), [FAQ](https://support.easypos.vn/) | M: bán hàng-hóa đơn-thuế; thông điệp thuế không phải xác nhận pháp lý |
| S29 | [Haravan POS](https://www.haravan.com/pages/phan-mem-quan-ly-cua-hang-hararetail), [cấu hình](https://help.haravan.com/docs/pos/settings/thiet-lap-cau-hinh-ban-hang/) | M/N: QR xác nhận, mobile, tồn, ca, bán nợ, đổi trả |
| S30 | [MobiFone 1POS](https://solutions.mobifone.vn/vi/quan-ly-ban-hang-mobifone-1pos) | M: phiên/quỹ, khách, phương thức, loyalty, hóa đơn |
| S31 | [Medlink Pharmacy](https://medlink.vn/pharmacy/) | M: gói nhà thuốc/chuỗi; liên thông là hãng công bố, chưa thử API |
| S32 | [LS Central](https://www.lsretail.com/products/ls-central-for-retail), [NaviWorld VN](https://naviworld.com.vn/vi/phan-mem-ban-le-ls-retail-naviworld/) | M: offline, replenishment, multi-store, bookings; chưa khảo sát manual |
| S33 | [Sapo: giá vốn sau nhập](https://help.sapo.vn/cach-tinh-gia-von-cua-san-pham-sau-khi-nhap-kho) | N: bình quân, chi phí mua phân bổ, hàng đang chuyển; kiểm lại công thức thay chép đoạn thiếu ngoặc |
| S34 | [KiotViet: bán hàng Retail](https://www.kiotviet.vn/huong-dan-su-dung-kiotviet/retail-ban-hang/ban-hang/) | N: chế độ/phím tắt, split payment, import hóa đơn, thu nợ QR; QR không đồng nghĩa xác nhận tự động |
| S35 | [PosApp: phụ thu](https://retail-docs.posapp.vn/quan-ly-san-pham/tao-nhanh-khuyen-mai-phu-thu-tu-app.md) | N: tiền/%, theo quỹ, điều kiện cộng dồn và mẫu in |
| S36 | [Sapo: cấu hình khuyến mại](https://help.sapo.vn/cau-hinh-ung-dung-khuyen-mai-tren-phan-mem-sapo) | N: một/nhiều chương trình; giá gốc hoặc tính tuần tự cho kết quả khác |
| S37 | [Sapo: đợt coupon](https://help.sapo.vn/thiet-lap-dot-phat-hanh-ma-giam-gia-tren-phan-mem-sapo), [đơn vị quy đổi](https://help.sapo.vn/them-moi-san-pham-co-don-vi-quy-doi-tren-phan-mem-sapo) | N: điều kiện/thời hạn/lần dùng; tỷ lệ quy đổi đã tạo không sửa |
| S38 | [Sapo: chuyển hàng](https://help.sapo.vn/tao-phieu-chuyen-hang-giua-cac-chi-nhanh-tren-sapo), [trả nhập](https://help.sapo.vn/hoan-tra-don-nhap-hang-tren-sapo-omni) | N: giữ/xuất/nhận; trả hàng khác nhận lại tiền; bài trả nhập có mâu thuẫn chiều công nợ |
| S39 | [Nhanh: chuyển kho](https://pos.manual.nhanh.vn/pos/kho-hang/chuyen-kho/thao-tac-chuyen-kho.md), [dự báo nhập](https://pos.manual.nhanh.vn/pos/kho-hang/du-bao-nhap-hang.md) | N: gọi hàng, phân phối tỷ lệ, chờ nhận; forecast chỉ là gợi ý; chuyển kho đọc phần chính |
| S40 | [Nhanh: trả hàng](https://pos.manual.nhanh.vn/pos/kenh-ban/cua-hang/tra-hang.md), [nợ quà](https://pos.manual.nhanh.vn/pos/kenh-ban/cua-hang/no-qua-tang.md), [combo](https://pos.manual.nhanh.vn/pos/san-pham/khainiem-sp/loai-san-pham/san-pham-combo.md) | N: có/không đơn gốc, nợ quà; combo có câu mở đầu không nhất quán với phần xuất kho |
| S41 | [MISA eShop: đổi/trả](https://helpeshop.misa.vn/ac/tra-hang) | I và ba bài N đã đọc: đổi nhanh, phát hành điều chỉnh/thay thế, chặn hủy liên quan; URL bài trong report |
| S42 | [iPOS: Deli Web Order](https://huongdan.ipos.vn/docs/tai-lieu-van-hanh-ipos-web-order-fabi/thao-tac-van-hanh-tai-cua-hang/doi-voi-don-deli-giao-hang-tan-noi/) | N: xác nhận/hủy/sửa, tự giao/Ahamove; phí thu khách khác cước trả tài xế, bài cũ cần kiểm phiên bản |
| S43 | [AMIS CRM: yêu cầu mua](https://helpcrm.misa.vn/kb/ket-noi-voi-amis-quy-trinh-quy-trinh-mua-hang/) | N: nối cơ hội/đơn với workflow và cập nhật trạng thái/đã nhận |

Marketing/CRM sâu hơn: [Haravan CRM Marketing](https://help.haravan.com/docs/customers/intro-new-loyalty/bo-giai-phap-crm-marketing/); mục lục dài: [Nhanh llms.txt](https://pos.manual.nhanh.vn/llms.txt), [PosApp retail llms.txt](https://retail-docs.posapp.vn/llms.txt). Danh bạ phía trên giữ website của các hãng chưa có bài nguồn `Sxx`.

<a id="nghien-cuu-con-lai"></a>

## Phần nghiên cứu chưa hoàn tất

**Chưa đạt yêu cầu tuyệt đối “tất cả phần mềm, toàn bộ mọi nội dung”.** Đã mở rộng phạm vi và tổng hợp backlog có nguồn; phần dưới là checklist nghiên cứu còn mở, không được đánh dấu xong chỉ vì có link website.

| Tên / đầu mối | Tình trạng trong đợt này | Cần xác minh trước khi thêm vào danh sách chuẩn |
| --- | --- | --- |
| GoSELL | [gosell.vn](https://gosell.vn/) và `www` lỗi DNS | Miền hiện hành, pháp nhân, gói, help; chưa kết luận ngừng hoạt động |
| ABIT | [abit.vn](https://abit.vn/) không trích xuất được | Trang sản phẩm/license/help hiện tại; không suy diễn không có sản phẩm |
| bePOS | [bepos.io](https://bepos.io/) hiện mô tả blog/checklist QA/QC | Sản phẩm POS/gói hiện hành khác blog; không dùng bài cũ làm trạng thái hiện tại |
| Nextsoft | [Trang nhà hàng](https://nextsoft.vn/san-pham/phan-mem-nha-hang) được search trả về nhưng fetch 404 | URL mới, giấy phép và hỗ trợ |
| An Việt Soft | [anvietsoft.com](https://anvietsoft.com/) đọc được, thiên thiết bị/tư vấn | Sản phẩm do hãng sở hữu hay đại lý, gói license/manual |
| Dsoft, DRS Manager/Quán Số | [dsoft.vn](https://dsoft.vn/) lỗi kết nối; [quanso.vn](http://quanso.vn/phan-mem-quan-ly-nha-hang-cafe) mới có dấu vết search | Pháp nhân, site HTTPS/hiện hành, sản phẩm và gói |
| VNUNI | Có dấu vết giới thiệu và Facebook, chưa xác minh website chính thức hoạt động | Không thay website hãng bằng site tải phần mềm bên thứ ba |
| POSBASIC, SaleX | [posbasic.net](https://posbasic.net/), [salex.vn](https://salex.vn/) là đầu mối bản trước, chưa đọc lại | Bán source/license hay đại lý; chỉ giữ ứng viên, không dùng làm bằng chứng |
| Bán Hàng Việt | [banhangviet.io.vn](https://banhangviet.io.vn/) không trích xuất được | Hãng/gói/license và docs; không nhầm với Park Việt |
| CloudGO, BMS, gói tùy biến | Website đọc được nhưng chưa kiểm toán lõi/giấy phép | Nếu dùng lõi mở/white-label, chuyển đúng nhóm thay vì gọi thuần đóng |
| Quốc tế khác | Dynamics 365 Commerce, Shopify POS và các nền tảng chuỗi | Website hãng, chào bán Việt Nam, điều kiện thanh toán/thuế/thiết bị |

### Checklist hoàn thiện nghiên cứu theo từng hãng

- [ ] R-01 — Hoàn thiện manifest mọi hãng từ sitemap, help, release/API, FAQ, điều khoản và video; [inventory JSON](../plans/reports/research-261012-2208-vn-pos-doc-index.json) chỉ bao phủ ba chỉ mục Nhanh/PosApp retail/UPOS mobile, không đại diện toàn thị trường.
- [ ] R-02 — Với mỗi URL lưu hãng/sản phẩm/phiên bản/loại nội dung/ngày đọc, trạng thái đọc đầy đủ-trích đoạn-lỗi-cần đăng nhập, tính năng và ràng buộc; không gọi chỉ đọc sitemap là đã đọc bài.
- [ ] R-03 — Đọc sâu hết nghiệp vụ retail trước: KiotViet, Sapo, MISA eShop, Nhanh, Haravan; sau đó từng hãng còn lại. Đánh dấu bài cũ và thay đổi giữa phiên bản/gói.
- [ ] R-04 — Đọc riêng FnB/nhà thuốc/spa/lưu trú và CRM/DMS; mọi tính năng chỉ có marketing giữ nhãn M tới khi có manual/demo được phép.
- [ ] R-05 — Video/PDF: lập danh mục, đọc transcript/tài liệu được truy cập công khai; không vượt đăng nhập/paywall hoặc tải bản quyền trái phép.
- [ ] R-06 — Đối chiếu gói dịch vụ/EULA/pháp nhân, alias/rebrand, lõi mở và đại lý; một gia đình sản phẩm không đếm lặp thành nhiều hãng.
- [ ] R-07 — Đối chiếu từng tính năng với bài và giới hạn, tiếp tục mở rộng khi xuất hiện tính năng chưa có; không biến “hãng A nói hãng B thiếu” thành kết luận.
- [ ] R-08 — Trước mỗi phase làm thật, kiểm lại tài liệu API/thuế hiện hành và tạo plan nhỏ trong `plans/` theo quy tắc repo; roadmap này là đầu vào, không tự triển khai app.

## Còn bỏ ngỏ

- Không có danh bạ toàn thị trường hoặc manifest đầy đủ mọi bài của mọi hãng; không thể cam kết tuyệt đối chỉ bằng các lượt search/fetch này.
- Chưa kiểm toán giấy phép/lõi của mọi sản phẩm; chưa thử bản trả phí, offline, hiệu năng, thiết bị và connector thực tế.
- Giá/gói/khuyến mại và nội dung website thay đổi; URL truy cập được không chứng minh tính năng khả dụng trong mọi gói.
- Quy định thuế/hóa đơn, GPP/dược và dữ liệu cá nhân cần xác minh nguồn pháp lý đang hiệu lực và người chịu trách nhiệm trước triển khai.
- Chưa chốt ngành pilot, đội ngũ, lịch sprint, nhà cung cấp hóa đơn/thanh toán/kênh đầu tiên; không tự gán lịch hoàn thành hoặc lựa chọn nhà cung cấp.
- Đã đối chiếu giảm giá toàn đơn, tiền thừa và chặn tồn với source/test hiện có; chưa chạy lại test hoặc kiểm thử UI trong đợt chỉ sửa tài liệu này.
