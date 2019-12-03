module ApplicationHelper
  def current_store
    store = current_user.stores.first
    unless store
      member = current_user.members.first
      if member.present?
        store = member.store
        unless store
          sign_out
          redirect_to root_path, alert: "Bạn không có quyền sử dụng trang web này. Vui lòng liên hệ với quản trị viên."
        end
      else
        sign_out
        redirect_to root_path, alert: "Bạn không có quyền sử dụng trang web này. Vui lòng liên hệ với quản trị viên. "
      end
    end
    store
  end

  def has_permission?(permission_name)
    if current_store.user == current_user
      true
    else
      member = current_store.members.where(user_id: current_user.id).first
      permissions = member.role.permissions || []
      permissions.include?(permission_name)
    end
  end

  def number_to_dong(number)
    number_to_currency(number, precision: 0, unit: '')
  end

  def number_to_dong_unit(number)
    number_to_currency(number, precision: 0, unit: '₫')
  end

  def number_to_vnd_unit(number)
    number_to_currency(number, precision: 0, unit: 'VND')
  end
end
