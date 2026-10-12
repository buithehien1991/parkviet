class HomeController < InertiaController
  def index
    return redirect_to manage_path if user_signed_in?
    render inertia: "workspace/welcome"
  end
end
