# frozen_string_literal: true

class Admin::BaseController < InertiaController
  react_layout "admin"

  before_action :authenticate_user!
  before_action :authenticate_admin!

  private

  def apply_admin_breadcrumbs(*items)
    breadcrumb "Admin", admin_root_path

    items.each do |item|
      breadcrumb(*item)
    end
  end
end
