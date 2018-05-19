class ApplicationController < ActionController::Base
  def get_districts
    html = ''
    if params[:province_id].present?
      province = Province.find(params[:province_id])
      districts = province.districts
      html += '<option value="">-- Chọn Quận/Huyện --</option>'
      districts.each do |district|
        html += '<option value="'+district.id.to_s+'">'+district.name.to_s+'</option>'
      end
    end
    render plain: html
  rescue ActiveRecord::RecordNotFound
    render plain: ''
  end
end
