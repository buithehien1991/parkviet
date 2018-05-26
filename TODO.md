## Manage
### Product Groups
- Edit product group
- Thêm position để order theo position bởi người dùng

### Producer
- Edit producer

## Common
- Add checking permission for delete: Product Group | Producer. Prevent hacking by check permission. 
- Add activity tracking to system. Should be put to background and should do after complete create new producer and before do other things
- Pagination

### Administrator
- Sử dụng Logstash (logstash-logger) + Elasticsearch + Kibana => Quản lý log
- Elasticsearch + Kibana => Theo dõi thói quen tìm kiếm của người dùng
- Kết hợp sử dụng docker để việc deploy sản phẩm trở lên dễ dàng

#### Admin dashboard
- For manage user/product

### Background processing
#### What use background jobs
- Index elasticsearch
- Export PDF/Word/Excel file - Integrate with Action Cable to use

#### Direction
- Use ActiveJobs. Trước tiên sử dụng AJ trước. Vì đã có nhiều kinh nghiệm với Sidekiq rồi nên dùng native xem có tốt hơn, dễ sử dụng hơn không. Thậm chí kết hợp cả 2 tùy vào tính chất mỗi công việc. 
- Use Sidekiq (Tốt hơn AJ khi cần set priority, retry task. Tóm lại sẽ tốt hơn AJ khi cần customize nhiều.)

### Autocomplete
- Using JqueryUI with autocomplete can be customize
- Our application use turbolink => How to adapt with turbolink when calling autocomplete: https://gorails.com/episodes/global-autocomplete-search

### Email system
