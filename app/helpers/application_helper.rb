module ApplicationHelper
  def current_store
    current_user.stores.first
  end
end
