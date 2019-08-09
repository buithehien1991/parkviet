class CustomerSerializer < ActiveModel::Serializer
  attributes :customer_type, :name, :code, :abbr_name, :phone, :email
end