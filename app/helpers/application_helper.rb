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
end
