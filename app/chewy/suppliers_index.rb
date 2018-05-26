class SuppliersIndex < Chewy::Index
  define_type Supplier.active do
    field :name, :code, :abbr_name, :phone
  end
end