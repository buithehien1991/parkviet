class Commune < ApplicationRecord
  belongs_to :district
  belongs_to :province
end
