class SupplierSerializer < ActiveModel::Serializer
  attributes :id, :supplier_type, :name, :code, :abbr_name, :phone, :email
end