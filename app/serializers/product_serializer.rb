class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :producer
  belongs_to :product_type
  belongs_to :product_group

  attributes :id, :name, :code, :abbr_name, :description, :cost_price, :sale_price, :vat, :in_stock, :in_stock_max, :in_stock_min, :status
  attribute :avatar_url

  # https://medium.com/@elenichappen/using-active-storage-with-active-model-serializers-36c91f5a0686
  def avatar_url
    if object.images.present?
      rails_blob_path(object.images.first, only_path: true)
    else
      ActionController::Base.helpers.image_url('no-image.png')
    end
  end
end