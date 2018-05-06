class Province < ApplicationRecord
  has_many :districts, foreign_key: :province_code, primary_key: :province_code
end
