json.extract! report, :id, :reportable_id, :title, :content, :user_id, :status, :created_at, :updated_at
json.url report_url(report, format: :json)
