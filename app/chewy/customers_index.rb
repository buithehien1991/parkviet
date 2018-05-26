class CustomersIndex < Chewy::Index
  define_type Customer.active do
    field :name, :code, :abbr_name, :phone
  end


end