class Commune < ApplicationRecord
  belongs_to :district, foreign_key: :commune_code
end
