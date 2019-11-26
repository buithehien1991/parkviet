class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :customer_type, :name, :code, :abbr_name, :phone, :email
end