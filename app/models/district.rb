class District < ApplicationRecord
  belongs_to :province, foreign_key: :province_code
  has_many :communes, foreign_key: :district_code, primary_key: :district_code
end
