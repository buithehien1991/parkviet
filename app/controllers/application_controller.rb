class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?

  def get_current_user
    if current_user.present?
      render :json => current_user.to_json
    else
      render :json => {}
    end
  end

  def get_districts
    html = ''
    if params[:province_id].present?
      province = Province.find(params[:province_id])
      districts = province.districts
      html += '<option value="">'+ t(:prompt_district_select) +'</option>'
      districts.each do |district|
        html += '<option value="'+district.id.to_s+'">'+district.name.to_s+'</option>'
      end
    end
    render plain: html
  rescue ActiveRecord::RecordNotFound
    render plain: ''
  end

  def get_communes
    html = ''
    if params[:district_id].present?
      district = District.find(params[:district_id])
      communes = district.communes
      html += '<option value="">' + t(:prompt_commune_select) + '</option>'
      communes.each do |commune|
        html += '<option value="'+commune.id.to_s+'">'+commune.name.to_s+'</option>'
      end
    end
    render plain: html
  rescue ActiveRecord::RecordNotFound
    render plain: ''
  end

  def current_store
    current_user.stores.first
  end

  def info_for_paper_trail
    { ip: request.remote_ip, user_agent: request.user_agent }
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
  end

end
