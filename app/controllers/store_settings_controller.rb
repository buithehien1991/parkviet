class StoreSettingsController < StoreController
  before_action { permit_store!("system_setting") }

  def edit
    render_settings
  end

  def update
    if current_store.update(params.require(:store).permit(:name, :phone, :address, :tax, :description))
      redirect_to edit_store_settings_path, notice: "Đã cập nhật thông tin cửa hàng."
    else
      render_settings(status: :unprocessable_content)
    end
  end

  private

  def render_settings(status: :ok)
    render inertia: "workspace/store-settings", props: {
      details: current_store.as_json(only: [ :name, :phone, :address, :tax, :description ]),
      errors: current_store.errors.to_hash(true).transform_values(&:first)
    }, status:
  end
end
